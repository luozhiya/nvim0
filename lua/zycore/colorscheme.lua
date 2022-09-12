-- require('vscode').change_style('dark')
vim.cmd([[
try
  colorscheme darkplus
catch /^Vim\%((\a\+)\)\=:E185/
  colorscheme default
  set background=dark
endtry
]])

-- Font
-- guifont = "monospace:h17"    -- the font used in graphical neovim application
vim.opt['guifont'] = 'inconsolata:h17' -- the font used in graphical neovim application
