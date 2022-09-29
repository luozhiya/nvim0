-- Automatically install packer
local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({
      'git',
      'clone',
      '--depth',
      '1',
      'https://github.com/wbthomason/packer.nvim',
      install_path,
    })
    vim.cmd([[packadd packer.nvim]])
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

require('packer').startup(function(use)
  -- System
  use('wbthomason/packer.nvim')
  use('nvim-lua/plenary.nvim') -- Note that this library is useless outside of Neovim since it requires Neovim functions.
  use('lewis6991/impatient.nvim') -- Improve startup time for Neovim

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
  use('akinsho/bufferline.nvim')
  use('moll/vim-bbye') -- Delete buffers and close files in Vim without closing your windows or messing up your layout.

  -- Easy VAX find
  use('nvim-telescope/telescope.nvim') -- Find, Filter, Preview, Pick. All lua, all the time.

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

  -- Lua
  use "folke/lua-dev.nvim" -- Dev setup for init.lua and plugin development with full signature help, docs and completion for the nvim lua API.
  use "jbyuki/one-small-step-for-vimkind" -- Debug adapter for Neovim plugins

  -- Debug
  use('mfussenegger/nvim-dap')
  use('rcarriga/nvim-dap-ui')
  use('theHamsta/nvim-dap-virtual-text')

  -- Colorscheme
  -- use 'Mofiqul/vscode.nvim' -- VSCode dark theme
  use('lunarvim/darkplus.nvim')
  use('luozhiya/darkpluspro.nvim')

  -- Completion
  use('hrsh7th/nvim-cmp') -- Autocompletion plugin
  use('hrsh7th/cmp-buffer')
  use('hrsh7th/cmp-path')
  use('saadparwaiz1/cmp_luasnip')
  use('hrsh7th/cmp-nvim-lsp') -- LSP source for nvim-cmp
  use('hrsh7th/cmp-nvim-lua')
  use('onsails/lspkind.nvim') -- vscode-like pictograms for neovim lsp completion items

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
