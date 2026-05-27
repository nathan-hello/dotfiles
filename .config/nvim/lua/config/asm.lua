local asm_group = vim.api.nvim_create_augroup("asm-view", { clear = true })

local function notify_err(msg)
  vim.notify(msg, vim.log.levels.ERROR)
end

local function shellescape(x)
  return vim.fn.shellescape(x)
end

local function is_abs_path(p)
  return p:match("^/") ~= nil or p:match("^[A-Za-z]:[\\/]") ~= nil
end

local function make_abs_path(p, cwd)
  if not p or p == "" then
    return nil
  end
  if is_abs_path(p) then
    return vim.fn.fnamemodify(p, ":p")
  end
  return vim.fn.fnamemodify((cwd or ".") .. "/" .. p, ":p")
end

local function is_build_dir(name)
  return name == "build"
    or name == "out"
    or name == ".build"
    or name:match("^cmake%-build") ~= nil
    or name:match("^build[-_]") ~= nil
    or name:match("^out[-_]") ~= nil
end

local function find_compile_commands_in_build_dirs(dir)
  local ok_read, entries = pcall(vim.fn.readdir, dir)
  if not ok_read or type(entries) ~= "table" then
    return nil
  end

  for _, name in ipairs(entries) do
    if is_build_dir(name) then
      local build_dir = dir .. "/" .. name
      if vim.fn.isdirectory(build_dir) == 1 then
        local direct = build_dir .. "/compile_commands.json"
        if vim.fn.filereadable(direct) == 1 then
          return vim.fn.fnamemodify(direct, ":p")
        end

        local matches = vim.fn.globpath(build_dir, "**/compile_commands.json", false, true)
        if type(matches) == "table" and #matches > 0 then
          return vim.fn.fnamemodify(matches[1], ":p")
        end
      end
    end
  end

  return nil
end

local function find_compile_commands(start_file)
  local dir = vim.fn.fnamemodify(start_file, ":p:h")

  while dir and dir ~= "" do
    local candidate = dir .. "/compile_commands.json"
    if vim.fn.filereadable(candidate) == 1 then
      return candidate
    end

    local build_candidate = find_compile_commands_in_build_dirs(dir)
    if build_candidate then
      return build_candidate
    end

    local parent = vim.fn.fnamemodify(dir, ":h")
    if parent == dir then
      break
    end
    dir = parent
  end

  return nil
end

local function load_compile_entry(src)
  local db_path = find_compile_commands(src)
  if not db_path then
    return nil, nil, "No compile_commands.json found"
  end

  local ok_read, lines = pcall(vim.fn.readfile, db_path)
  if not ok_read then
    return nil, nil, "Failed to read " .. db_path
  end

  local ok_json, db = pcall(vim.fn.json_decode, table.concat(lines, "\n"))
  if not ok_json or type(db) ~= "table" then
    return nil, nil, "Failed to parse " .. db_path
  end

  local abs_src = vim.fn.fnamemodify(src, ":p")

  for _, entry in ipairs(db) do
    local cwd = entry.directory or vim.fn.fnamemodify(db_path, ":h")
    local entry_file = make_abs_path(entry.file, cwd)

    if entry_file == abs_src then
      return entry, db_path, nil
    end
  end

  return nil, db_path, "File not found in compile_commands.json"
end

local function parse_output_from_args(args)
  for i, arg in ipairs(args) do
    if arg == "-o" and args[i + 1] then
      return args[i + 1]
    end

    local inline = arg:match("^%-o(.+)$")
    if inline and inline ~= "" then
      return inline
    end
  end

  return nil
end

local function parse_output_from_command(cmd)
  local parts = vim.split(cmd, "%s+", { trimempty = true })

  for i, arg in ipairs(parts) do
    if arg == "-o" and parts[i + 1] then
      return parts[i + 1]
    end

    local inline = arg:match("^%-o(.+)$")
    if inline and inline ~= "" then
      return inline
    end
  end

  return nil
end

local function get_output_path(entry, db_path)
  local cwd = entry.directory or vim.fn.fnamemodify(db_path, ":h")
  local out = entry.output

  if not out and type(entry.arguments) == "table" then
    out = parse_output_from_args(entry.arguments)
  end

  if not out and type(entry.command) == "string" then
    out = parse_output_from_command(entry.command)
  end

  if not out then
    return nil
  end

  return make_abs_path(out, cwd)
end

local function run_compile_entry(entry, db_path)
  local cwd = entry.directory or vim.fn.fnamemodify(db_path, ":h")

  if type(entry.arguments) == "table" and vim.system then
    local result = vim.system(entry.arguments, {
      cwd = cwd,
      text = true,
    }):wait()

    local out = (result.stdout or "") .. (result.stderr or "")
    return result.code == 0, out
  end

  local cmd = entry.command
  if not cmd and type(entry.arguments) == "table" then
    local escaped = {}
    for _, arg in ipairs(entry.arguments) do
      table.insert(escaped, shellescape(arg))
    end
    cmd = table.concat(escaped, " ")
  end

  if not cmd then
    return false, "Invalid compile_commands entry"
  end

  local old_cwd = vim.fn.getcwd()
  local ok_chdir, err = pcall(vim.fn.chdir, cwd)
  if not ok_chdir then
    return false, tostring(err)
  end

  local out = vim.fn.system(cmd)
  local code = vim.v.shell_error

  pcall(vim.fn.chdir, old_cwd)

  return code == 0, out
end

local function get_current_function_name(buf)
  local ok_util, lsp_util = pcall(require, "vim.lsp.util")
  if not ok_util then
    return nil
  end

  local params = {
    textDocument = lsp_util.make_text_document_params(buf),
  }

  local results =
    vim.lsp.buf_request_sync(buf, "textDocument/documentSymbol", params, 1000)

  if not results then
    return nil
  end

  local cursor = vim.api.nvim_win_get_cursor(0)
  local line0 = cursor[1] - 1

  local function flatten(items, out)
    for _, item in ipairs(items or {}) do
      table.insert(out, item)
      if item.children then
        flatten(item.children, out)
      end
    end
  end

  local symbols = {}
  for _, res in pairs(results) do
    if res.result then
      flatten(res.result, symbols)
    end
  end

  local best = nil

  for _, sym in ipairs(symbols) do
    local range = sym.range or (sym.location and sym.location.range)
    local kind = sym.kind

    if
      range
      and (kind == 6 or kind == 9 or kind == 12)
      and range.start.line <= line0
      and line0 <= range["end"].line
    then
      local span = range["end"].line - range.start.line
      if not best or span < best.span then
        best = {
          name = sym.name,
          span = span,
        }
      end
    end
  end

  if best then
    return best.name
  end

  return nil
end

local function open_or_get_asm_buf()
  local name = "ASM://llvm-objdump"

  for _, b in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(b) and vim.api.nvim_buf_get_name(b) == name then
      return b
    end
  end

  local b = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_name(b, name)
  vim.bo[b].buftype = "nofile"
  vim.bo[b].bufhidden = "wipe"
  vim.bo[b].swapfile = false
  vim.bo[b].filetype = "asm"
  vim.bo[b].modifiable = true
  return b
end

local function ensure_source_left_asm_right(src_buf, asm_buf)
  local asm_wins = vim.fn.win_findbuf(asm_buf)
  if #asm_wins > 0 then
    vim.api.nvim_set_current_win(asm_wins[1])
    return
  end

  local src_wins = vim.fn.win_findbuf(src_buf)
  if #src_wins > 0 then
    vim.api.nvim_set_current_win(src_wins[1])
  end

  vim.cmd("rightbelow vsplit")
  vim.api.nvim_win_set_buf(0, asm_buf)
end

local function find_function_line(lines, function_name)
  if not function_name or function_name == "" then
    return 1
  end

  for i, line in ipairs(lines) do
    if
      line:find("<", 1, true)
      and line:find(">:", 1, true)
      and line:find(function_name, 1, true)
    then
      return i
    end
  end

  for i, line in ipairs(lines) do
    if line:find(function_name, 1, true) then
      return i
    end
  end

  return 1
end

local function disassemble_current_function()
  local src_buf = vim.api.nvim_get_current_buf()
  local src = vim.api.nvim_buf_get_name(src_buf)

  if src == "" then
    notify_err("Buffer has no file path (save it first).")
    return
  end

  if vim.bo[src_buf].modified then
    vim.cmd("write")
  end

  local entry, db_path, load_err = load_compile_entry(src)
  if not entry then
    notify_err(load_err or "Failed to load compile_commands entry")
    return
  end

  local obj = get_output_path(entry, db_path)
  if not obj then
    notify_err("Could not determine object file path from compile_commands.json")
    return
  end

  local ok_compile, compile_out = run_compile_entry(entry, db_path)
  if not ok_compile then
    notify_err("Compile failed:\n" .. (compile_out or ""))
    return
  end

  if vim.fn.filereadable(obj) ~= 1 then
    notify_err("Compile succeeded but object file was not found:\n" .. obj)
    return
  end

  local function_name = get_current_function_name(src_buf)

  local cmd = table.concat({
    "llvm-objdump",
    "-M intel",
    "--demangle",
    "--disassemble",
    "--no-leading-addr",
    "--no-show-raw-insn",
    shellescape(obj),
  }, " ")

  local asm = vim.fn.system(cmd)
  if vim.v.shell_error ~= 0 then
    notify_err("llvm-objdump failed:\n" .. (asm or ""))
    return
  end

  if not asm or asm == "" then
    notify_err("No disassembly produced.")
    return
  end

  local asm_buf = open_or_get_asm_buf()
  local lines = vim.split(asm, "\n", { plain = true })
  local target_line = find_function_line(lines, function_name)

  vim.bo[asm_buf].modifiable = true
  vim.api.nvim_buf_set_lines(asm_buf, 0, -1, false, lines)
  vim.bo[asm_buf].modifiable = false

  ensure_source_left_asm_right(src_buf, asm_buf)
  vim.api.nvim_win_set_cursor(0, { target_line, 0 })
end

vim.keymap.set("n", "<leader>da", disassemble_current_function, {
  desc = "Disassemble current file and jump to current function",
})

vim.api.nvim_create_autocmd("BufWritePost", {
  group = asm_group,
  pattern = { "*.c", "*.h", "*.cc", "*.hh", "*.cpp", "*.hpp", "*.cxx", "*.hxx", "*.C" },
  callback = function()
    for _, b in ipairs(vim.api.nvim_list_bufs()) do
      if vim.api.nvim_buf_is_loaded(b) and vim.api.nvim_buf_get_name(b) == "ASM://llvm-objdump" then
        disassemble_current_function()
        break
      end
    end
  end,
})
