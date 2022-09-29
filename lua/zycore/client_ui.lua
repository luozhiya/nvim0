local hardworking = require('zycore.base.hardworking')
local rpc = require('zycore.base.rpc_communication')
local fn = vim.fn
local opt = vim.opt

-- Client UI

local is_neovide = function()
  return vim.fn.exists('neovide') == 1
end

if is_neovide() then
  vim.g.neovide_fullscreen = true
elseif hardworking.is_gui_running() then
  -- Neovim don't has any flags
  rpc.notify_popupmenu(false)
  rpc.notify_tabline(false)
end
