local hardworking = require('zycore.base.hardworking')

local M = {}

-- Communication with client
local rpcnotify = vim.rpcnotify

-- neovim-qt' client info is lack some information
local support_clients = {
  'nvim-qt',
  'neovide',
}
M.support_clients = support_clients

local compat_nvim_qt = true
M.compat_nvim_qt = compat_nvim_qt

-- Channel
local fetch_client = function()
  for i, chan in pairs(vim.api.nvim_list_chans()) do
    local id = chan.id
    local client = chan.client
    -- hardworking.dump(chan)
    if client ~= nil and client.name == nil and client['true'] == 6 and compat_nvim_qt then
      -- print(id)
      -- hardworking.dump(client)
      return id, client
    end
    if client ~= nil and vim.tbl_contains(support_clients, client.name) and client.type == 'ui' then
      return id, client
    end
  end
end

local fetch_channel = function()
  local channel = M.channel
  if channel == nil then
    channel, _ = fetch_client()
  end
  if channel ~= nil then
    return channel
  end
end

local notify_close = function()
  return rpcnotify(fetch_channel(), 'Gui', 'Close')
end
M.notify_close = notify_close

local notify_font = function(fontname, force)
  return rpcnotify(fetch_channel(), 'Gui', 'Font', fontname, force)
end
M.notify_font = notify_font

local notify_linespace = function(spacing)
  return rpcnotify(fetch_channel(), 'Gui', 'Linespace', spacing)
end
M.notify_linespace = notify_linespace

local notify_mousehide = function(enable)
  return rpcnotify(fetch_channel(), 'Gui', 'Mousehide', enable)
end
M.notify_mousehide = notify_mousehide

local notify_tabline = function(enable)
  return rpcnotify(fetch_channel(), 'Gui', 'Option', 'Tabline', enable)
end
M.notify_tabline = notify_tabline

local notify_popupmenu = function(enable)
  return rpcnotify(fetch_channel(), 'Gui', 'Option', 'Popupmenu', enable)
end
M.notify_popupmenu = notify_popupmenu

local setup = function()
  M.channel, M.client = fetch_client()
end
M.setup = setup

return M
