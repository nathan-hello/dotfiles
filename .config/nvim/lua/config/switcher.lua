local M = {}

local function get_current_path()
  local name = vim.api.nvim_buf_get_name(0)
  if name == "" then
    return nil
  end

  local relative = vim.fn.fnamemodify(name, ":.")
  if relative ~= "" then
    return relative
  end

  return name
end

local function switch_file_pair(ext_a, ext_b)
  local path = get_current_path()
  if not path then
    vim.notify("Current buffer has no file path", vim.log.levels.WARN)
    return
  end

  local root = vim.fn.fnamemodify(path, ":r")
  local current_ext = vim.fn.fnamemodify(path, ":e")
  local exts = { ext_b, ext_a }

  if current_ext == ext_a:sub(2) then
    exts = { ext_b, ext_a }
  elseif current_ext == ext_b:sub(2) then
    exts = { ext_a, ext_b }
  end

  for _, ext in ipairs(exts) do
    local target = root .. ext
    if vim.loop.fs_stat(target) then
      vim.cmd.edit(vim.fn.fnameescape(target))
      return
    end
  end

  vim.notify("No matching file found for " .. path, vim.log.levels.WARN)
end

local function same_file(path_a, path_b)
  if not path_a or not path_b then
    return false
  end

  return (vim.loop.fs_realpath(path_a) or path_a) == (vim.loop.fs_realpath(path_b) or path_b)
end

local function location_path(location)
  local uri = location.uri or location.targetUri
  if not uri then
    return nil
  end

  return vim.uri_to_fname(uri)
end

local function collect_locations(result)
  if not result then
    return {}
  end

  if vim.islist(result) then
    return result
  end

  return { result }
end

local function open_location(location)
  local path = location_path(location)
  if not path then
    return false
  end

  local range = location.range or location.targetSelectionRange or location.targetRange
  if not range then
    return false
  end

  vim.cmd.edit(vim.fn.fnameescape(path))
  pcall(vim.api.nvim_win_set_cursor, 0, { range.start.line + 1, range.start.character })
  return true
end

local function jump_to_counterpart_symbol(target_path, methods)
  local bufnr = vim.api.nvim_get_current_buf()
  local clients = vim.lsp.get_clients({ bufnr = bufnr })
  local client = clients[1]
  if not client then
    return false
  end

  local params = vim.lsp.util.make_position_params(0, client.offset_encoding)

  for _, method in ipairs(methods) do
    local responses = vim.lsp.buf_request_sync(bufnr, method, params, 300)
    if responses then
      for _, response in pairs(responses) do
        for _, location in ipairs(collect_locations(response.result)) do
          local path = location_path(location)
          if path and same_file(path, target_path) then
            return open_location(location)
          end
        end
      end
    end
  end

  return false
end

function M.switch_cpp_header()
  switch_file_pair(".cpp", ".hpp")
end

function M.switch_c_header()
  switch_file_pair(".c", ".h")
end

function M.switch_source_header()
  local path = get_current_path()
  if not path then
    vim.notify("Current buffer has no file path", vim.log.levels.WARN)
    return
  end

  local ext = vim.fn.fnamemodify(path, ":e")
  if ext == "cpp" or ext == "hpp" then
    local target = vim.fn.fnamemodify(path, ":r") .. (ext == "cpp" and ".hpp" or ".cpp")
    if jump_to_counterpart_symbol(target, { "textDocument/implementation", "textDocument/declaration", "textDocument/definition" }) then
      return
    end

    return switch_file_pair(".cpp", ".hpp")
  end

  if ext == "c" or ext == "h" then
    local target = vim.fn.fnamemodify(path, ":r") .. (ext == "c" and ".h" or ".c")
    if jump_to_counterpart_symbol(target, { "textDocument/implementation", "textDocument/declaration", "textDocument/definition" }) then
      return
    end

    return switch_file_pair(".c", ".h")
  end

  vim.notify("Unsupported file type: " .. ext, vim.log.levels.WARN)
end

return M
