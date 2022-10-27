local lualine = require('lualine')
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
  local chars = { '__', '▁▁', '▂▂', '▃▃', '▄▄', '▅▅', '▆▆', '▇▇', '██' }
  local line_ratio = current_line / total_lines
  local index = math.ceil(line_ratio * #chars)
  return chars[index]
end

local ratio_progress = function()
  local current_line = vim.fn.line('.')
  local total_lines = vim.fn.line('$')
  local line_ratio = current_line / total_lines * 100
  -- return tostring(line_ratio) ☯️
  return string.format('%02d ', line_ratio)
end

local spaces = function()
  return 'spaces: ' .. vim.api.nvim_buf_get_option(0, 'shiftwidth')
end

local opts = {
  options = {
    color = { fg = style_constexpr.palette.white, bg = style_constexpr.palette.vs_blue },
    -- color = { fg = style_constexpr.palette.white, bg = '#131313' },
    icons_enabled = true,
    theme = 'auto',
    component_separators = { left = '', right = '' },
    section_separators = { left = '', right = '' },
    -- NvimTree
    -- disabled_filetypes = { 'alpha', 'dashboard', 'NvimTree', 'Outline' },
    disabled_filetypes = { 'alpha', 'dashboard', 'Outline' },
    always_divide_middle = true,
  },
  sections = {
    lualine_a = {
      branch,
      diagnostics,
    },
    lualine_b = { mode },
    lualine_c = {
      {
        'filename',
        file_status = true, -- Displays file status (readonly status, modified status)
        newfile_status = false, -- Display new file status (new file means no write after created)
        path = 1, -- 0: Just the filename
        -- 1: Relative path
        -- 2: Absolute path
        -- 3: Absolute path, with tilde as the home directory

        shorting_target = 40, -- Shortens path to leave 40 spaces in the window
        -- for other components. (terrible name, any suggestions?)
        symbols = {
          modified = '[+]', -- Text to show when the file is modified.
          readonly = '[-]', -- Text to show when the file is non-modifiable or readonly.
          unnamed = '[No Name]', -- Text to show for unnamed buffers.
          newfile = '[New]', -- Text to show for new created file before first writting
        },
      },
    },
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
}

lualine.setup(opts)
