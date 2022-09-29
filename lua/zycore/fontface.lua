local hardworking = require('zycore.base.hardworking')
local nnoremap = hardworking.nnoremap
local inoremap = hardworking.inoremap
local vnoremap = hardworking.vnoremap
local xnoremap = hardworking.xnoremap

local rpc = require('zycore.base.rpc_communication')

-- print(rpc.client_id)
-- print(rpc.client_name)

local codefont
local codefontsize
local cjkfont
local cjkfontsize

if hardworking.is_windows() then
  codefontsize = 11
  cjkfontsize = codefontsize
  codefont = 'JetBrainsMono Nerd Font Mono'
  cjkfont = 'Sarasa Mono SC Nerd'
else
  codefontsize = 15
  cjkfontsize = codefontsize
  codefont = 'CaskaydiaCove Nerd Font SemiLight'
  cjkfont = 'Sarasa Mono SC Nerd'
end

local AdjustFontSize = function(amount)
  codefontsize = codefontsize + amount
  cjkfontsize = cjkfontsize + amount
  local codefontname = codefont .. ':h' .. tostring(codefontsize)
  local cjkfontname = cjkfont .. ':h' .. tostring(cjkfontsize)
  rpc.notify_font(codefontname, true)
  vim.opt.guifont = codefontname
  vim.opt.guifontwide = cjkfontname
end

-- Init font size
AdjustFontSize(0)

-- Global function to map call
function __ADJUST_FONTSIZE_ZOOMIN()
  AdjustFontSize(1)
end

function __ADJUST_FONTSIZE_ZOOMOUT()
  AdjustFontSize(-1)
end

-- In normal/insert mode, adjust font size by ctrl + mouse middle scroll
nnoremap('<C-ScrollWheelUp>', ':lua __ADJUST_FONTSIZE_ZOOMIN()<CR>')
nnoremap('<C-ScrollWheelDown>', ':lua __ADJUST_FONTSIZE_ZOOMOUT()<CR>')
inoremap('<C-ScrollWheelUp>', '<Esc>:lua __ADJUST_FONTSIZE_ZOOMIN()<CR>')
inoremap('<C-ScrollWheelDown>', '<Es>:lua __ADJUST_FONTSIZE_ZOOMOUT()<CR>')

-- In normal mode, pressing numpad's+ increases the font
-- nnoremap('<kPlus>', ':lua __ADJUST_FONTSIZE_ZOOMIN()<CR>')
-- nnoremap('<kMinus>', ':lua __ADJUST_FONTSIZE_ZOOMOUT()<CR>')
vim.cmd([[
noremap <kPlus> :lua __ADJUST_FONTSIZE_ZOOMIN()<CR>
noremap <kMinus> :lua __ADJUST_FONTSIZE_ZOOMOUT()<CR>
]])

-- In insert mode, pressing ctrl + numpad's+ increases the font
-- inoremap('<C-kPlus>', '<Esc>:lua __ADJUST_FONTSIZE_ZOOMIN()<CR>')
-- inoremap('<C-Minus>', '<Esc>:lua __ADJUST_FONTSIZE_ZOOMOUT()<CR>')
vim.cmd([[
noremap <C-kPlus> :<Esc>:lua __ADJUST_FONTSIZE_ZOOMIN()<CR>a
noremap <C-Minus> :<Esc>:lua __ADJUST_FONTSIZE_ZOOMOUT()<CR>a
]])

