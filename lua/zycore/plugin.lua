local M = {}

local fn = vim.fn
local hardworking = require('zycore.base.hardworking')

-- Note stdpath()
-- more detail on help stdpath()
-- config User configuration directory. |init.vim| is stored here.
--        /home/luozhiya/.config/nvim/
-- cache  Cache directory: arbitrary temporary storage for plugins, etc. maybe log
--        /home/luozhiya/.cache/nvim/
-- data   User data directory.
--        /home/luozhiya/.local/share/nvim/
-- log    Logs directory (for use by plugins too).
--        /home/luozhiya/.local/state/nvim/

-- local packpath = hardworking.join_paths(fn.stdpath('config'), 'site')
-- local package_root = hardworking.join_paths(fn.stdpath('config'), 'site', 'pack')
-- local install_path = hardworking.join_paths(package_root, 'packer', 'start', 'packer.nvim')
-- local compile_path = hardworking.join_paths(fn.stdpath('config'), 'plugin', 'packer_compiled.lua')
local config = fn.stdpath('config')
local packpath = config .. '/site'
local package_root = packpath .. '/pack'
local packer_dir = package_root .. '/packer'
M.packer_dir = packer_dir
local install_path = packer_dir .. '/start/packer.nvim'
local compile_path = config .. '/plugin/packer_compiled.lua'

-- vim.cmd([[set packpath=/tmp/nvim/site]])
vim.opt.runtimepath:append(config)
-- lua-dev diagnostics show vim.opt.packpath is a string, but it is table type actually
-- ignore diagnostics warning
-- 这个是关键，只有设置了这个 packloadall 才会执行成功，require('packer') 才正常
vim.opt.packpath:append(packpath)
-- E5113: Error while calling lua chunk: zycore/plugin.lua:17: attempt to concatenate field 'packpath' (a table value)
-- print(vim.opt.packpath)
-- vim.opt.packpath = vim.opt.packpath .. ';' .. packpath
-- print(vim.opt.packpath)

-- Automatically install packer
local ensure_packer = function()
  -- local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({
      'git',
      'clone',
      '--depth',
      '1',
      'https://github.com/wbthomason/packer.nvim',
      install_path,
    })
    vim.cmd([[packloadall! packer.nvim]])
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

-- Inital package root dir and compiled path
require('packer').init({
  package_root = package_root,
  compile_path = compile_path,
})

require('packer').startup(function(use)
  -- System
  use('wbthomason/packer.nvim')
  use('nvim-lua/plenary.nvim') -- Note that this library is useless outside of Neovim since it requires Neovim functions.
  use('lewis6991/impatient.nvim') -- Improve startup time for Neovim

  -- Lisp
  use('Olical/aniseed') -- Neovim configuration and plugins in Fennel (Lisp compiled to Lua)
  use('Olical/conjure') -- Interactive evaluation for Neovim (Clojure, Fennel, Janet, Racket, Hy, MIT Scheme, Guile)

  -- LSP
  use('neovim/nvim-lspconfig') -- Configurations for Nvim LSP
  use('williamboman/nvim-lsp-installer') -- Simple to install LSP servers

  -- treesitter
  use('nvim-treesitter/nvim-treesitter') -- Nvim Treesitter configurations and abstraction layer
  use('JoosepAlviste/nvim-ts-context-commentstring') -- Neovim treesitter plugin for setting the commentstring based on the cursor location in a file.

  -- Keyboard
  use('folke/which-key.nvim')

  -- UI/File tree/Status/Tab/Buffer
  use('delphinus/dwm.nvim') -- Tiled Window Management
  use('goolord/alpha-nvim')
  use('kyazdani42/nvim-web-devicons')
  use('kyazdani42/nvim-tree.lua')
  use('nvim-lualine/lualine.nvim')
  -- use('akinsho/bufferline.nvim')
  use('luozhiya/bufferline.nvim')
  use('moll/vim-bbye') -- Delete buffers and close files in Vim without closing your windows or messing up your layout.
  use('kazhala/close-buffers.nvim') -- 📑 Delete multiple vim buffers based on different conditions
  use('j-hui/fidget.nvim') -- Standalone UI for nvim-lsp progress

  -- Easy VAX find
  use('nvim-telescope/telescope.nvim') -- Find, Filter, Preview, Pick. All lua, all the time.
  use('nvim-telescope/telescope-fzy-native.nvim') -- FZY style sorter that is compiled

  -- Project
  use('ahmedkhalf/project.nvim')

  -- Code
  use('RRethy/vim-illuminate') -- automatically highlighting other uses of the word under the cursor using either LSP, Tree-sitter, or regex matching.
  use('numToStr/Comment.nvim') -- Smart and powerful comment plugin for neovim
  use('windwp/nvim-autopairs') -- autopairs for neovim written by lua
  use('lukas-reineke/indent-blankline.nvim') -- Indent guides for Neovim
  use('NMAC427/guess-indent.nvim') -- Automatic indentation style detection for Neovim
  use('andrewferrier/wrapping.nvim') -- Plugin to make it easier to switch between 'soft' and 'hard' line wrapping in NeoVim
  use('norcalli/nvim-colorizer.lua') -- The fastest Neovim colorizer.
  use('ray-x/lsp_signature.nvim') -- LSP signature hint as you type
  use('folke/trouble.nvim') -- 🚦 A pretty diagnostics, references, telescope results, quickfix and location list to help you solve all the trouble your code is causing.
  -- use('ericcurtin/CurtineIncSw.vim') -- Switch from *.c* to *.h* and vice versa
  -- use({
  --   'jakemason/ouroboros.nvim',
  --   requires = { { 'nvim-lua/plenary.nvim' } },
  -- }) -- Allows quickly switching between header and implementation files for C/C++ in Neovim.

  -- Format
  use('jose-elias-alvarez/null-ls.nvim') -- Inject LSP diagnostics, code actions, and more via Lua
  use('sbdchd/neoformat') -- why not use .clang-format?
  use('rhysd/vim-clang-format')
  use('cappyzawa/trim.nvim') --  trims trailing whitespace and lines
  use('mhartington/formatter.nvim') --  A format runner for Neovim.
  use('lukas-reineke/lsp-format.nvim') -- A wrapper around Neovims native LSP formatting.

  -- C++
  use('m-pilia/vim-ccls') -- supports some additional methods provided by ccls, which are not part of the standard Language Server Protocol (LSP)
  use('jackguo380/vim-lsp-cxx-highlight') -- semantic highlighting using the language server protocol.
  use('p00f/clangd_extensions.nvim') -- Clangd's off-spec features for neovim's LSP client.
  use('stevearc/aerial.nvim') -- Neovim plugin for a code outline window

  -- Lua
  use('folke/lua-dev.nvim') -- Dev setup for init.lua and plugin development with full signature help, docs and completion for the nvim lua API.
  use('jbyuki/one-small-step-for-vimkind') -- Debug adapter for Neovim plugins

  -- Debug
  use('mfussenegger/nvim-dap')
  use('rcarriga/nvim-dap-ui')
  use('theHamsta/nvim-dap-virtual-text')

  -- Colorscheme
  -- use 'Mofiqul/vscode.nvim' -- VSCode dark theme
  -- use('lunarvim/darkplus.nvim')
  use('luozhiya/darkplus.nvim')
  use('luozhiya/omegadark.nvim')

  -- Completion
  use('hrsh7th/nvim-cmp') -- Autocompletion plugin
  use('hrsh7th/cmp-buffer')
  use('hrsh7th/cmp-path')
  use('saadparwaiz1/cmp_luasnip')
  use('hrsh7th/cmp-nvim-lsp') -- LSP source for nvim-cmp
  use('hrsh7th/cmp-nvim-lua')
  use('onsails/lspkind.nvim') -- vscode-like pictograms for neovim lsp completion items
  use('rktjmp/hotpot.nvim') -- Carl Weathers #1 Neovim Plugin.
  use('PaterJason/cmp-conjure') -- nvim-cmp source for conjure.
  use('hrsh7th/cmp-calc') -- nvim-cmp source for math calculation
  use('hrsh7th/cmp-vsnip') -- nvim-cmp source for vim-vsnip

  -- Snippets
  use('L3MON4D3/LuaSnip')
  use('rafamadriz/friendly-snippets')

  -- Git
  use('lewis6991/gitsigns.nvim') -- Git integration for buffers

  -- Terminal
  use('akinsho/toggleterm.nvim')

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end
end)

require('zycore.one')

return M
