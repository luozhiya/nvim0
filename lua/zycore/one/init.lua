local option = require('zycore.one.option')

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
require('zycore.one.impatient')
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

-- UI/Misc
local keymap = require('zycore.one.keymap')
local vim_command = require('zycore.one.vim_commmand')
local title = require('zycore.one.title')
local colorscheme = require('zycore.one.colorscheme')
local client_ui = require('zycore.one.client_ui')
local fontface = require('zycore.one.fontface')

local lsp = require('zycore.one.lsp')
-- After LSP
local clangd_extensions = require('zycore.one.clangd_extensions')
