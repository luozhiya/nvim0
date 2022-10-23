local g = vim.g
local cmd = vim.cmd
local opt = vim.opt

local hardworking = require('zycore.base.hardworking')

-- Pack path
-- https://neovim.io/doc/user/repeat.html#packages
local config = hardworking.config_path
local packpath = hardworking.packpath

-- vim.cmd([[set packpath=/tmp/nvim/site]])
opt.runtimepath:append(config)
-- lua-dev diagnostics show vim.opt.packpath is a string, but it is table type actually
-- ignore diagnostics warning
-- 这个是关键，只有设置了这个 packloadall 才会执行成功，require('packer') 才正常
opt.packpath:append(packpath)
-- E5113: Error while calling lua chunk: zycore/plugin.lua:17: attempt to concatenate field 'packpath' (a table value)
-- print(vim.opt.packpath)
-- vim.opt.packpath = vim.opt.packpath .. ';' .. packpath
-- print(vim.opt.packpath)

-- First needed
local impatient = require('zycore.one.impatient')
local notify_nvim = require('zycore.one.notify_nvim')

-- Packer
local plugins = require('zycore.one.packer_nvim')
local packer_bootstrap = plugins.ensure_packer()

-- Packer commands
local create_cmd = vim.api.nvim_create_user_command
create_cmd('PackerInstall', function()
  cmd [[packadd packer.nvim]]
  plugins.install()
end, {})
create_cmd('PackerUpdate', function()
  cmd [[packadd packer.nvim]]
  plugins.update()
end, {})
create_cmd('PackerSync', function()
  cmd [[packadd packer.nvim]]
  plugins.sync()
end, {})
create_cmd('PackerClean', function()
  cmd [[packadd packer.nvim]]
  plugins.clean()
end, {})
create_cmd('PackerCompile', function()
  cmd [[packadd packer.nvim]]
  plugins.compile()
end, {})

-- Basic
local option = require('zycore.one.option')
local keymap = require('zycore.one.keymap')

-- Plugin
require('zycore.one.cmp')
require('zycore.one.format')
require('zycore.one.formatter_nvim')
require('zycore.one.comment')
require('zycore.one.treesitter')
require('zycore.one.autocommands')
require('zycore.one.nvim_tree')
require('zycore.one.which_key')
require('zycore.one.telescope')
require('zycore.one.illuminate')
require('zycore.one.lualine')
require('zycore.one.bufferline')
require('zycore.one.nvim_autopairs')
require('zycore.one.toggleterm')
require('zycore.one.project')
require('zycore.one.indent_blankline')
require('zycore.one.alpha')
require('zycore.one.gitsigns')
local dap = require('zycore.one.dap_nvim')
require('zycore.one.dapui')
require('zycore.one.trim')
local wrapping = require('zycore.one.wrapping')
local numbers = require('zycore.one.number')
local guess_indent = require('zycore.one.guess_indent')
require('zycore.one.null_ls')
require('zycore.one.lua_dev')
require('zycore.one.colorizer')
require('zycore.one.aerial')
require('zycore.one.lsp_signature_nvim')
require('zycore.one.trouble')
require('zycore.one.close_buffer_nvim')
require('zycore.one.ouroboros')
-- require('zycore.one.hotpot_nvim')
require('zycore.one.fidget_nvim')
require('zycore.one.neogit_nvim')
require('zycore.one.lsp_lines_nvim')
require('zycore.one.true_zen')
require('zycore.one.matchparen_nvim')
require('zycore.one.nvim_spectre')
require('zycore.one.nvim_bqf')

-- UI/Misc
local vim_command = require('zycore.one.vim_commmand')
local title = require('zycore.one.title')
local colorscheme = require('zycore.one.colorscheme')
local client_ui = require('zycore.one.client_ui')
local fontface = require('zycore.one.fontface')

-- LSP
local clangd_extensions = require('zycore.one.clangd_extensions')
local lsp = require('zycore.one.lsp')

