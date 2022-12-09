-- Refs
-- https://github.com/LunarVim/Neovim-from-scratch
-- https://github.com/wbthomason/dotfiles/tree/linux/neovim/.config/nvim
-- https://github.com/akinsho/dotfiles/tree/main/.config/nvim
-- https://git.sr.ht/~yazdan/nvim-config/tree
-- nvim\site\pack\packer\opt\nvim-cmp\lua\cmp\utils\misc.lua
-- https://github.com/wbthomason/packer
-- https://github.com/j-hui/fidget.nvim
-- site\pack\packer\opt\nvim-lspconfig\lua\lspconfig\util.lua

local zycore = require('zycore')
-- local packer_dir = require('zycore').packer_dir

-- local s = {}
-- vim.notify('init finished', vim.log.levels.TRACE, s)

-- local ensure_installed = function(user, repo)
--   local ok, results = pcall(vim.fs.find, repo, { path = packer_dir, type = 'directory' })
--   if not ok or #results == 0 then
--     local cmd = string.format('!git clone https://github.com/%s/%s %s/start/%s', user, repo, packer_dir, repo)
--     vim.cmd(cmd)
--     vim.cmd('packadd ' .. repo)
--   end
-- end
--
-- ensure_installed('Olical', 'aniseed')

vim.g['aniseed#env'] = {
  module = 'zylisp.init',
  compile = true,
}

local zylisp = require('zylisp')
