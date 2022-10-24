local g = vim.g
local cmd = vim.cmd
local opt = vim.opt
local api = vim.api

local M = {}

local plugins = require('zycore.one.packer_nvim')
local packer_bootstrap = plugins.ensure_packer()

-- Packer commands
local create_cmd = vim.api.nvim_create_user_command
create_cmd('PackerInstall', function()
  cmd([[packadd packer.nvim]])
  plugins.install()
end, {})
create_cmd('PackerUpdate', function()
  cmd([[packadd packer.nvim]])
  plugins.update()
end, {})
create_cmd('PackerSync', function()
  cmd([[packadd packer.nvim]])
  plugins.sync()
end, {})
create_cmd('PackerClean', function()
  cmd([[packadd packer.nvim]])
  plugins.clean()
end, {})
create_cmd('PackerCompile', function()
  cmd([[packadd packer.nvim]])
  plugins.compile()
end, {})
create_cmd('PackerStatus', function()
  cmd([[packadd packer.nvim]])
  plugins.status()
end, {})

return M
