local hardworking = require('zycore.base.hardworking')
local nnoremap = hardworking.nnoremap
local inoremap = hardworking.inoremap
local vnoremap = hardworking.vnoremap
local xnoremap = hardworking.xnoremap
local cnoremap = hardworking.cnoremap
local rpc = require('zycore.base.rpc_communication')
local fn = vim.fn
local opt = vim.opt

-- Client UI

local is_neovide = function()
  return vim.fn.exists('neovide') == 1
end

local function toggle_fullscreen()
  if vim.g.neovide_fullscreen then
    vim.cmd([[let g:neovide_fullscreen = v:false]])
  else
    vim.cmd([[let g:neovide_fullscreen = v:true]])
  end
end

-- vim.api.nvim_create_user_command('ToggleClientUIFullscreen', function()
--   if vim.g.neovide_fullscreen then
--     vim.cmd([[let g:neovide_fullscreen = v:false]])
--   else
--     vim.cmd([[let g:neovide_fullscreen = v:true]])
--   end
-- end, {})


if is_neovide() then
  -- vim.g.neovide_fullscreen = true
  vim.g.neovide_remember_window_size = true
  vim.g.neovide_refresh_rate_idle = 60
  vim.g.neovide_no_idle = true
  vim.keymap.set('', '<C-F12>', toggle_fullscreen)
  -- vim.g.neovide_cursor_vfx_mode = ''
  -- vim.api.nvim_feedkeys('^X@sq', 'n', true)
  -- nnoremap('<S-F12>', ':ToggleClientUIFullscreen<cr>')
  -- inoremap('<S-F12>', ':ToggleClientUIFullscreen<cr>')
  -- vnoremap('<S-F12>', ':ToggleClientUIFullscreen<cr>')
  -- xnoremap('<S-F12>', ':ToggleClientUIFullscreen<cr>')
  -- cnoremap('<S-F12>', ':ToggleClientUIFullscreen<cr>')
  -- vim.keymap.set('n', '<F12>', '<ESC>:ToggleClientUIFullscreen<cr>')
  -- vim.keymap.set('i', '<F12>', '<ESC>:ToggleClientUIFullscreen<cr>')
  -- vim.cmd([[let g:neovide_fullscreen = v:true]])
  -- vim.keymap.set("n", "<leader>xf", function()
  --     vim.g.neovide_fullscreen = not vim.g.neovide_fullscreen
  -- end, { desc = "Toggle GUI Full Screen" })
  -- vim.api.nvim_set_keymap('n', '<F12>', ':let g:neovide_fullscreen = !g:neovide_fullscreen<CR>', {})
elseif hardworking.is_gui_running() then
  -- Neovim don't has any flags
  rpc.notify_popupmenu(false)
  rpc.notify_tabline(false)
end
