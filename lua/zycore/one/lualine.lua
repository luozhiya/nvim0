local lualine_ok, lualine = pcall(require, 'lualine')
if not lualine_ok then
  return
end

local style_constexpr = require('zycore.base.style_constexpr')

local hide_in_width = function()
  return vim.fn.winwidth(0) > 80
end

local diagnostics = {
  'diagnostics',
  sources = { 'nvim_diagnostic' },
  sections = { 'error', 'warn' },
  symbols = {
    error = style_constexpr.icons.lsp.error .. ' ',
    warn = style_constexpr.icons.lsp.warn .. ' ',
  },
  colored = false,
  update_in_insert = false,
  always_visible = true,
}

-- 
local diff = {
  'diff',
  colored = false,
  symbols = {
    added = style_constexpr.icons.git.add,
    modified = style_constexpr.icons.git.mod,
    removed = style_constexpr.icons.git.remove,
  }, -- changes diff symbols
  cond = hide_in_width,
}

local mode = {
  'mode',
  fmt = function(str)
    return '-- ' .. str .. ' --'
  end,
}

local filetype = {
  'filetype',
  icons_enabled = false,
  icon = nil,
}

local fileformat = {
  'fileformat',
  icons_enabled = false,
  icon = nil,
}

local branch = {
  'branch',
  icons_enabled = true,
  icon = '',
}

local location = {
  'location',
  padding = 0,
}

-- cool function for progress
local progress = function()
  local current_line = vim.fn.line('.')
  local total_lines = vim.fn.line('$')
  local chars =
    { '__', '▁▁', '▂▂', '▃▃', '▄▄', '▅▅', '▆▆', '▇▇', '██' }
  local line_ratio = current_line / total_lines
  local index = math.ceil(line_ratio * #chars)
  return chars[index]
end

local ratio_progress = function()
  local current_line = vim.fn.line('.')
  local total_lines = vim.fn.line('$')
  local line_ratio = current_line / total_lines * 100
  -- return tostring(line_ratio)
  return string.format('%02d', line_ratio)
end

local spaces = function()
  return 'spaces: ' .. vim.api.nvim_buf_get_option(0, 'shiftwidth')
end

lualine.setup({
  options = {
    color = { fg = style_constexpr.palette.white, bg = style_constexpr.palette.vs_blue },
    icons_enabled = true,
    theme = 'auto',
    component_separators = { left = '', right = '' },
    section_separators = { left = '', right = '' },
    -- NvimTree
    disabled_filetypes = { 'alpha', 'dashboard', 'NvimTree', 'Outline' },
    always_divide_middle = true,
  },
  sections = {
    lualine_a = { branch, diagnostics },
    lualine_b = { mode },
    lualine_c = {},
    -- lualine_x = { "encoding", "fileformat", "filetype" },
    lualine_x = { diff, spaces, 'encoding', fileformat, filetype },
    lualine_y = { location },
    lualine_z = { ratio_progress },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { 'filename' },
    lualine_x = { 'location' },
    lualine_y = {},
    lualine_z = {},
  },
  tabline = {},
  extensions = {},
})
