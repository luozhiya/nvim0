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
-- vim.opt['guifont'] = 'Inconsolata Nerd Font:h17' -- the font used in graphical neovim application

if vim.fn.has('unix') == 1 then
  local uname = vim.fn.system('uname')
  if uname == 'Darwin\n' then
    vim.opt.guifont = 'JetBrains Mono:h11'
  else
    vim.opt['guifont'] = 'inconsolata:h17' -- the font used in graphical neovim application
  end
else
  vim.cmd([[
  if has('win32')
    autocmd GUIEnter * simalt ~x  " always maximize initial GUI window
    set guifont=Consolas:h11
    if has("directx")
      set renderoptions=type:directx
    endif
  endif
  ]])
end

