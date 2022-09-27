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
    " set guifont=Consolas:h11
    " set guifont=CaskaydiaCove_Nerd_Font_Mono:h16
    " set guifont=CaskaydiaCove\ Nerd\ Font\ Mono:h16
    " set guifontwide=Microsoft\ Yahei:h12
    " set guifontwide=Microsoft_YaHei_Mono:h12.5:cGB2312
    " set guioptions+=!
    " set guifontwide=Microsoft\ Yahei\ Mono:h12
    " set guifont=Microsoft\ Yahei\ Mono:h12
    " set guifontwide=Sarasa\ Mono\ SC\ Nerd:h11
  if has("directx")
      set renderoptions=type:directx
    endif
  endif
  ]])
end

if vim.fn.has('gui_running') then
--  if vim.fn.has('win32') then
--    vim.opt.guifont = JetBrainsMono_NF:h11,Sarasa\ Mono\ SC:h11
--  end
  vim.cmd([[
    if has('win32')
      " set guifont=JetBrainsMono_Nerd_Font_Mono:h11,Sarasa\ Mono\ SC\ Nerd:h11
      " set guifont=JetBrainsMono\ Nerd\ Font\ Mono:h12
      " set guifont=JetBrainsMono\ Nerd\ Font\ Mono:h11,更纱黑体\ Mono\ SC\ Nerd:h11
      " set guifontwide=Sarasa\ Mono\ SC\ Nerd:h11
    endif
  ]])
end
