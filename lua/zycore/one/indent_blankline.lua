local indent_blankline = require('indent_blankline')
local g = vim.g

g.indentLine_enabled = true
g.indent_blankline_use_treesitter = true
g.indentLine_faster = 1
g.indentLine_fileTypeExclude = { 'tex', 'markdown', 'txt', 'startify', 'packer' }
g.indent_blankline_show_trailing_blankline_indent = false
g.indent_blankline_show_first_indent_level = true
g.indent_blankline_show_current_context = true
g.indent_blankline_buftype_exclude = { 'terminal', 'nofile' }
g.indent_blankline_filetype_exclude = {
  'help',
  'startify',
  'dashboard',
  'packer',
  'neogitstatus',
  'NvimTree',
  'Trouble',
}
g.indent_blankline_char = '│'
-- g.indent_blankline_char = '▏'
-- g.indent_blankline_char = '' -- ⏽ ▏ 
-- g.indent_blankline_char = "▎"
g.indent_blankline_context_patterns = {
  'class',
  'return',
  'function',
  'method',
  '^if',
  '^while',
  'jsx_element',
  '^for',
  '^object',
  '^table',
  'block',
  'arguments',
  'if_statement',
  'else_clause',
  'jsx_element',
  'jsx_self_closing_element',
  'try_statement',
  'catch_clause',
  'import_statement',
  'operation_type',
}
-- HACK: work-around for https://github.com/lukas-reineke/indent-blankline.nvim/issues/59
vim.wo.colorcolumn = '99999'

-- vim.cmd([[highlight IndentBlanklineIndent2 guifg=#E5C07B gui=nocombine]])
-- vim.cmd([[highlight IndentBlanklineIndent1 guifg=#E06C75 gui=nocombine]])
-- vim.cmd([[highlight IndentBlanklineIndent3 guifg=#98C379 gui=nocombine]])
-- vim.cmd([[highlight IndentBlanklineIndent4 guifg=#56B6C2 gui=nocombine]])
-- vim.cmd([[highlight IndentBlanklineIndent5 guifg=#61AFEF gui=nocombine]])
-- vim.cmd([[highlight IndentBlanklineIndent6 guifg=#C678DD gui=nocombine]])
--
-- vim.cmd([[highlight IndentSpaceIndent1 guibg=#E06C75 blend=30 gui=nocombine]])
-- vim.cmd([[highlight IndentSpaceIndent2 guibg=#E5C07B blend=30 gui=nocombine]])
-- vim.cmd([[highlight IndentSpaceIndent3 guibg=#98C379 blend=30 gui=nocombine]])
-- vim.cmd([[highlight IndentSpaceIndent4 guibg=#56B6C2 blend=30 gui=nocombine]])
-- vim.cmd([[highlight IndentSpaceIndent5 guibg=#61AFEF blend=30 gui=nocombine]])
-- vim.cmd([[highlight IndentSpaceIndent6 guibg=#C678DD blend=30 gui=nocombine]])

-- vim.opt.list = true
-- vim.opt.listchars:append('space:⋅')
-- vim.opt.listchars:append('space:')
-- vim.opt.listchars:append('space:')
-- vim.opt.listchars:append('eol:↴')

vim.cmd([[highlight IndentBlanklineIndent1 guifg=#E06C75 gui=nocombine]])
vim.cmd([[highlight IndentBlanklineIndent2 guifg=#E5C07B gui=nocombine]])
vim.cmd([[highlight IndentBlanklineIndent3 guifg=#98C379 gui=nocombine]])
vim.cmd([[highlight IndentBlanklineIndent4 guifg=#56B6C2 gui=nocombine]])
vim.cmd([[highlight IndentBlanklineIndent5 guifg=#61AFEF gui=nocombine]])
vim.cmd([[highlight IndentBlanklineIndent6 guifg=#C678DD gui=nocombine]])

-- vim.opt.list = true
-- vim.opt.listchars:append "space:⋅"
-- vim.opt.listchars:append "eol:↴"

local opts = {
  show_end_of_line = true,
  show_current_context = true,
  show_current_context_start = true,
  -- space_char_highlight_list = {
  --   'IndentSpaceIndent1',
  --   'IndentSpaceIndent2',
  --   'IndentSpaceIndent3',
  --   'IndentSpaceIndent4',
  --   'IndentSpaceIndent5',
  --   'IndentSpaceIndent6',
  -- },
  show_trailing_blankline_indent = false,

  space_char_blankline = ' ',
  char_highlight_list = {
    'IndentBlanklineIndent1',
    'IndentBlanklineIndent2',
    'IndentBlanklineIndent3',
    'IndentBlanklineIndent4',
    'IndentBlanklineIndent5',
    'IndentBlanklineIndent6',
  },
}

indent_blankline.setup(opts)
