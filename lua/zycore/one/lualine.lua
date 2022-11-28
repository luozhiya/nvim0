local lualine = require('lualine')
local style_constexpr = require('zycore.base.style_constexpr')
local get_mode = vim.api.nvim_get_mode

vim.cmd([[
" Setup the colors
function! s:setup_colors() abort
  if g:colors_name ==# 'nazgul'
    let s:bg_color = '#222222'
    let s:fg_color = '#e9e9e9'
  else
    let s:bg_color = synIDattr(synIDtrans(hlID('Statusline')), 'bg#', 'gui')
    let s:fg_color = synIDattr(synIDtrans(hlID('Statusline')), 'fg#', 'gui')
  endif

  exec 'hi Statusline guifg=' . s:fg_color . ' guibg=' . s:bg_color . ' gui=none'
  exec 'hi StatuslineSeparator guifg=' . s:bg_color . ' gui=none guibg=none'
  exec 'hi StatuslineNormal guibg=' . s:bg_color . ' gui=none guifg=' . s:fg_color
  exec 'hi StatuslineVC guibg=' . s:bg_color . ' gui=none guifg=#a9a9a9'
  exec 'hi StatuslineNormalAccent guibg=#403834 gui=bold guifg=' . s:fg_color
  exec 'hi StatuslineInsertAccent guifg=' . s:fg_color . ' gui=bold guibg=#726b67'
  exec 'hi StatuslineReplaceAccent guifg=' . s:fg_color . ' gui=bold guibg=#afaf00'
  exec 'hi StatuslineConfirmAccent guifg=' . s:fg_color . ' gui=bold guibg=#83adad'
  exec 'hi StatuslineTerminalAccent guifg=' . s:fg_color . ' gui=bold guibg=#6f6f6f'
  exec 'hi StatuslineMiscAccent guifg=' . s:fg_color . ' gui=bold guibg=#948d89'
endfunction

augroup statusline_colors
  au!
  au ColorScheme * call s:setup_colors()
augroup END

call s:setup_colors()
]])

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
  diff_color = {
    -- Same color values as the general color option can be used here.
    added = 'DiffAdd', -- Changes the diff's added color
    modified = 'DiffChange', -- Changes the diff's modified color
    removed = 'DiffDelete', -- Changes the diff's removed color you
  },
  symbols = {
    added = style_constexpr.icons.git.add,
    modified = style_constexpr.icons.git.mod,
    removed = style_constexpr.icons.git.remove,
  }, -- changes diff symbols
  cond = hide_in_width,
}

-- local mode = {
--   'mode',
--   fmt = function(str)
--     return '-- ' .. str .. ' --'
--   end,
-- }

local mode_table = {
  n = 'Normal',
  no = 'N·Operator Pending',
  v = 'Visual',
  V = 'V·Line',
  ['^V'] = 'V·Block',
  s = 'Select',
  S = 'S·Line',
  ['^S'] = 'S·Block',
  i = 'Insert',
  ic = 'Insert',
  R = 'Replace',
  Rv = 'V·Replace',
  c = 'Command',
  cv = 'Vim Ex',
  ce = 'Ex',
  r = 'Prompt',
  rm = 'More',
  ['r?'] = 'Confirm',
  ['!'] = 'Shell',
  t = 'Terminal',
}

local function mode_name(mode)
  return string.upper(mode_table[mode] or 'V-Block')
end

local function update_colors(mode)
  local mode_color = 'StatuslineMiscAccent'
  if mode == 'n' then
    mode_color = 'StatuslineNormalAccent'
  elseif mode == 'i' or mode == 'ic' then
    mode_color = 'StatuslineInsertAccent'
  elseif mode == 'R' then
    mode_color = 'StatuslineReplaceAccent'
  elseif mode == 'c' then
    mode_color = 'StatuslineConfirmAccent'
  elseif mode == 't' then
    mode_color = 'StatuslineTerminalAccent'
  else
    mode_color = 'StatuslineMiscAccent'
  end
  return mode_color
end

local mode = function()
  local mode = get_mode().mode
  local mode_color = update_colors(mode)
  -- local mode_format = '#%s# %s'
  -- return mode_format.format(mode_color, mode_name(mode))
  return mode_name(mode)
end

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
  -- https://github.com/nvim-lualine/lualine.nvim/issues/895#issuecomment-1323644475
  -- in string.format you need to esape the parcents too.
  -- So in this case you need 4 %. first escape gets interpreted and removed by string.format 2nd one gets removed by status line interpreter.
  -- return tostring(line_ratio) ☯️   
  return string.format('%02d%%%% ', line_ratio)
end

local spaces = function()
  return 'spaces: ' .. vim.api.nvim_buf_get_option(0, 'shiftwidth')
end

local lsp_active = function()
  -- buf_get_clients
  -- get_active_clients
  local clients = vim.lsp.buf_get_clients()
  local names = {}
  for _, client in pairs(clients) do
    table.insert(names, client.name)
  end
  return 'Lsp<' .. table.concat(names, ', ') .. '>'
end

local filename = {
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
}

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
      diff,
      diagnostics,
    },
    lualine_b = { mode },
    lualine_c = { filename },
    -- lualine_x = { "encoding", "fileformat", "filetype" },
    -- lualine_x = { diff, spaces, 'encoding', fileformat, filetype },
    lualine_x = { lsp_active, 'encoding', fileformat, filetype },
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
