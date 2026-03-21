local function truncate_left(text, max_width)
  if max_width <= 0 then
    return ""
  end

  if vim.fn.strdisplaywidth(text) <= max_width then
    return text
  end

  local ellipsis = "..."
  local ellipsis_width = vim.fn.strdisplaywidth(ellipsis)
  if max_width <= ellipsis_width then
    return string.rep(".", max_width)
  end

  local target_width = max_width - ellipsis_width
  local chars = vim.fn.strchars(text)

  for start = 1, chars do
    local suffix = vim.fn.strcharpart(text, start)
    if vim.fn.strdisplaywidth(suffix) <= target_width then
      return ellipsis .. suffix
    end
  end

  return ellipsis .. vim.fn.strcharpart(text, chars - 1)
end

local function format_harpoon_path(path, width)
  local label = tostring(path and path ~= "" and path or "-")
  label = vim.fn.fnamemodify(label, ":~:.")
  return truncate_left(label, width)
end

local function pad_right(text, width)
  local text_width = vim.fn.strdisplaywidth(text)
  if text_width >= width then
    return text
  end

  return text .. string.rep(" ", width - text_width)
end

local function build_harpoon_lines(width)
  local ok, harpoon = pcall(require, "harpoon")
  if not ok then
    return {}
  end

  local keys = {"1", "2", "3", "4", "q", "w", "e", "r"}

  local slots = 8
  local items = harpoon:list().items or {}
  local lines = {}

  for i = 1, slots do
    local item = items[i]
    local path = item and item.value or ""
    local content = string.format("%s) %s", keys[i], format_harpoon_path(path, width - 3))
    lines[i] = pad_right(content, width)
  end

  return lines
end

local overlay = {
  buf = nil,
  win = nil,
}

local function ensure_overlay_buf()
  if overlay.buf and vim.api.nvim_buf_is_valid(overlay.buf) then
    return overlay.buf
  end

  overlay.buf = vim.api.nvim_create_buf(false, true)
  vim.bo[overlay.buf].buftype = "nofile"
  vim.bo[overlay.buf].bufhidden = "wipe"
  vim.bo[overlay.buf].swapfile = false
  vim.bo[overlay.buf].modifiable = false
  return overlay.buf
end

local function overlay_size()
  return 30, 8
end

local function overlay_config()
  local width, height = overlay_size()
  return {
    relative = "editor",
    anchor = "NW",
    row = math.max(0, vim.o.lines - vim.o.cmdheight - height),
    col = math.max(0, vim.o.columns - width),
    width = width,
    height = height,
    style = "minimal",
    focusable = false,
    noautocmd = true,
    zindex = 60,
  }
end

local function ensure_overlay()
  local buf = ensure_overlay_buf()
  local config = overlay_config()

  if overlay.win and vim.api.nvim_win_is_valid(overlay.win) then
    pcall(vim.api.nvim_win_set_config, overlay.win, config)
    return overlay.win, buf
  end

  overlay.win = vim.api.nvim_open_win(buf, false, config)
  vim.wo[overlay.win].wrap = false
  vim.wo[overlay.win].number = false
  vim.wo[overlay.win].relativenumber = false
  vim.wo[overlay.win].signcolumn = "no"
  vim.wo[overlay.win].cursorline = false
  vim.wo[overlay.win].foldcolumn = "0"
  vim.wo[overlay.win].statuscolumn = ""
  return overlay.win, buf
end

local function render_overlay()
  local _, buf = ensure_overlay()
  if not buf then
    return
  end

  local width, _height = overlay_size()
  local lines = build_harpoon_lines(width)

  vim.bo[buf].modifiable = true
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].modifiable = false
end

function _G.refresh_harpoon_bar()
  vim.schedule(render_overlay)
end

vim.api.nvim_create_autocmd({ "VimEnter", "VimResized", "WinResized", "FocusGained" }, {
  callback = function()
    render_overlay()
  end,
})
