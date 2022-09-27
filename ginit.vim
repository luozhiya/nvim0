" Enable Mouse
set mouse=a

let s:codefont = "JetBrainsMono Nerd Font Mono"
let s:cjkfont = "Sarasa Mono SC Nerd"

" let g:guifontname = 'JetBrainsMono\ Nerd\ Font\ Mono,Sarasa\ Mono\ SC\ Nerd'
" let s:default_guifontheight = 22

" Set Editor Font
if exists(':GuiFont')
    " Use GuiFont! to ignore font errors
    " GuiFont! Inconsolata Nerd Font Mono:h13
    if has('win32')
        " GuiFont! CaskaydiaCove Nerd Font Mono:h11
        " GuiFont! JetBrainsMono Nerd Font Mono:h11
        " set guifontwide=Sarasa\ Mono\ SC\ Nerd:h11
        " set guifontwide=Sarasa_Mono_SC_Nerd:h11
        " let &guifontwide = "Sarasa Mono SC Nerd:h12"
    endif
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

let s:fontsize = 11
function! AdjustFontSize(amount)
  let s:fontsize = s:fontsize+a:amount
  " :execute "GuiFont! Consolas:h" . s:fontsize
  :execute "GuiFont! " . s:codefont . ":h" . s:fontsize
  " :execute "set guifontwide=Sarasa_Mono_SC_Nerd:h" . s:fontsize
  :execute "let &guifontwide = \"" . s:cjkfont . ":h". s:fontsize . "\""
endfunction

:call AdjustFontSize(0)

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

