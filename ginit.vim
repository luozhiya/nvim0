" Enable Mouse
set mouse=a

" choose the primary font, and cjk fallback font
if has('win32')
  let s:codefontsize = 13
  let s:cjkfontsize = s:codefontsize
  let s:codefont = "JetBrainsMono Nerd Font Mono"
  let s:cjkfont = "Sarasa Mono SC Nerd"
else
  let s:codefontsize= 15
  let s:cjkfontsize = s:codefontsize
  " Caskaydia Cove 
  " Cascadia Code
  let s:codefont = "CaskaydiaCove Nerd Font SemiLight"
  " let s:codefont = "Sarasa Mono SC Nerd"
  " Neovim-QT cannot input chinese in Arch Linux
  " let s:cjkfont = "Sarasa Mono SC Nerd"
  let s:cjkfont = s:codefont
endif

" Disable GUI Tabline
if exists(':GuiTabline')
  GuiTabline 0
endif

" Disable GUI Popupmenu
if exists(':GuiPopupmenu')
  GuiPopupmenu 0
endif

" Enable GUI ScrollBar
if exists(':GuiScrollBar')
  GuiScrollBar 1
endif

" Right Click Context Menu (Copy-Cut-Paste)
nnoremap <silent><RightMouse> :call GuiShowContextMenu()<CR>
inoremap <silent><RightMouse> <Esc>:call GuiShowContextMenu()<CR>
xnoremap <silent><RightMouse> :call GuiShowContextMenu()<CR>gv
snoremap <silent><RightMouse> <C-G>:call GuiShowContextMenu()<CR>gv

" Set Editor Font
function! AdjustFontSize(amount)
  let s:codefontsize = s:codefontsize+a:amount
  let s:cjkfontsize = s:cjkfontsize+a:amount
  " Use GuiFont! to ignore font errors
  " My patched neovim-qt always force ignore font errors
  if exists(':GuiFont')
    :execute "GuiFont! " . s:codefont . ":h" . s:codefontsize
  endif
  :execute "let &guifontwide = \"" . s:cjkfont . ":h". s:cjkfontsize . "\""
endfunction

" Init font size
:call AdjustFontSize(0)

" In normal/insert mode, adjust font size by ctrl + mouse middle scroll
noremap <C-ScrollWheelUp> :call AdjustFontSize(1)<CR>
noremap <C-ScrollWheelDown> :call AdjustFontSize(-1)<CR>
inoremap <C-ScrollWheelUp> <Esc>:call AdjustFontSize(1)<CR>a
inoremap <C-ScrollWheelDown> <Esc>:call AdjustFontSize(-1)<CR>a

" In normal mode, pressing numpad's+ increases the font
noremap <kPlus> :call AdjustFontSize(1)<CR>
noremap <kMinus> :call AdjustFontSize(-1)<CR>

" In insert mode, pressing ctrl + numpad's+ increases the font
inoremap <C-kPlus> <Esc>:call AdjustFontSize(1)<CR>a
inoremap <C-kMinus> <Esc>:call AdjustFontSize(-1)<CR>a

" 自动切换输入法，但是neovim-qt本身不支持输入法？
if !has('win32') 
  "##### auto fcitx  ###########
  let g:input_toggle = 1
  function! Fcitx2en()
     let s:input_status = system("fcitx-remote")
     if s:input_status == 2
        let g:input_toggle = 1
        let l:a = system("fcitx-remote -c")
     endif
  endfunction
  
  function! Fcitx2zh()
     let s:input_status = system("fcitx-remote")
     if s:input_status != 2 && g:input_toggle == 1
        let l:a = system("fcitx-remote -o")
        let g:input_toggle = 0
     endif
  endfunction
  
  set ttimeoutlen=150
  "Exit insert mode
  autocmd InsertLeave * call Fcitx2en()
  "Enter insert mode
  autocmd InsertEnter * call Fcitx2zh()
  "##### auto fcitx end ######
endif
