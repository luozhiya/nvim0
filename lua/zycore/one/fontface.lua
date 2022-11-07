local hardworking = require('zycore.base.hardworking')
local nnoremap = hardworking.nnoremap
local inoremap = hardworking.inoremap
local vnoremap = hardworking.vnoremap
local xnoremap = hardworking.xnoremap

local rpc = require('zycore.base.rpc_communication')

local is_neovide = function()
  return vim.fn.exists('neovide') == 1
end

-- print(rpc.client_id)
-- print(rpc.client_name)

-- l Light
-- sl SemiLight
-- r Regular

local codefont
local codefontsize
local codefontstyle
local cjkfont
local cjkfontsize
local cjkfontstyle

if hardworking.is_windows() then
  codefontsize = 13
  cjkfontsize = codefontsize
  -- codefont = 'CaskaydiaCove Nerd Font'
  -- codefont = 'Consolas'
  codefontstyle = 'l'
  codefont = 'Inconsolata Nerd Font Mono'
  -- codefont = 'JetBrainsMono Nerd Font Mono'
  -- codefont = 'FiraCode Nerd Font Mono'
  -- cjkfont = 'Sarasa Mono SC Nerd'
  if is_neovide() then
    codefontsize = 13
    codefont = 'JetBrainsMono Nerd Font Mono'
  end
  cjkfont = codefont
  cjkfontstyle = codefontstyle
else
  codefontsize = 17
  cjkfontsize = codefontsize
  -- codefont = 'CaskaydiaCove Nerd Font SemiLight'
  -- codefont = 'FiraCode Nerd Font Mono'
  -- codefont = 'JetBrainsMono Nerd Font Mono'
  codefont = 'Inconsolata Nerd Font Mono'
  if is_neovide() then
    codefontsize = 15
    codefont = 'JetBrainsMono Nerd Font Mono'
  end
  codefontstyle = 'sl'
  -- cjkfont = 'Sarasa Mono SC Nerd'
  cjkfont = codefont
  cjkfontstyle = codefontstyle
end

local MaybeNotifyClientFontChanged = function(fontname)
  if rpc.client ~= nil then
    rpc.notify_font(fontname, true)
  end
end

local AdjustFontSize = function(amount)
  codefontsize = codefontsize + amount
  cjkfontsize = cjkfontsize + amount
  -- local codefontname = codefont .. ':h' .. tostring(codefontsize) .. ':' .. codefontstyle
  -- local cjkfontname = cjkfont .. ':h' .. tostring(cjkfontsize) .. ':' .. cjkfontstyle
  local codefontname = codefont .. ':h' .. tostring(codefontsize)
  local cjkfontname = cjkfont .. ':h' .. tostring(cjkfontsize)
  MaybeNotifyClientFontChanged(codefontname)
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
