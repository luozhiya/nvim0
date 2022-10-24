local fn = vim.fn

local hardworking = require('zycore.base.hardworking')
local config = hardworking.config_path
local packpath = hardworking.packpath
local package_root = hardworking.package_root

local packer_dir = package_root .. '/packer'
local install_path = packer_dir .. '/start/packer.nvim'
local compile_path = config .. '/plugin/packer_compiled.lua'

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
    vim.cmd([[packadd packer.nvim]])
    return true
  end
  return false
end

local packer = nil
local function init()
  if packer == nil then
    packer = require('packer')
    packer.init({
      package_root = package_root,
      compile_path = compile_path,
      disable_commands = true,
      display = {
        open_fn = function()
          local result, win, buf = require('packer.util').float({
            border = {
              { '╭', 'FloatBorder' },
              { '─', 'FloatBorder' },
              { '╮', 'FloatBorder' },
              { '│', 'FloatBorder' },
              { '╯', 'FloatBorder' },
              { '─', 'FloatBorder' },
              { '╰', 'FloatBorder' },
              { '│', 'FloatBorder' },
            },
          })
          vim.api.nvim_win_set_option(win, 'winhighlight', 'NormalFloat:Normal')
          return result, win, buf
        end,
      },
    })
  end

  local use = packer.use
  packer.reset()

  -- System
  -- Packer
  use('wbthomason/packer.nvim')
  use('nvim-lua/plenary.nvim') -- Note that this library is useless outside of Neovim since it requires Neovim functions.
  use('lewis6991/impatient.nvim') -- Improve startup time for Neovim

  -- Fennel
  use('Olical/aniseed') -- Neovim configuration and plugins in Fennel (Lisp compiled to Lua)
  use('Olical/conjure') -- Interactive evaluation for Neovim (Clojure, Fennel, Janet, Racket, Hy, MIT Scheme, Guile)
  -- use('rktjmp/hotpot.nvim') -- Carl Weathers #1 Neovim Plugin.

  -- LSP
  use('neovim/nvim-lspconfig') -- Configurations for Nvim LSP
  use('williamboman/nvim-lsp-installer') -- Simple to install LSP servers
  use({ 'https://git.sr.ht/~whynothugo/lsp_lines.nvim', as = 'lsp_lines.nvim' }) -- Show nvim diagnostics using virtual lines
  use('j-hui/fidget.nvim') -- Standalone UI for nvim-lsp progress

  -- treesitter
  use('nvim-treesitter/nvim-treesitter') -- Nvim Treesitter configurations and abstraction layer
  use('JoosepAlviste/nvim-ts-context-commentstring') -- Neovim treesitter plugin for setting the commentstring based on the cursor location in a file.
  use('p00f/nvim-ts-rainbow') -- Rainbow parentheses for neovim using tree-sitter.
  use('nvim-treesitter/nvim-treesitter-textobjects') -- Syntax aware text-objects, select, move, swap, and peek support.

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
  use('rcarriga/nvim-notify') -- A fancy, configurable, notification manager for NeoVim
  use('monkoose/matchparen.nvim') -- alternative to default neovim matchparen plugin
  use('Pocco81/true-zen.nvim') -- Clean and elegant distraction-free writing for NeoVim

  -- Quickfix
  use({
    'Olical/vim-enmasse',
    -- cmd = 'EnMasse',
  }) -- Edit every line in a quickfix list at the same time
  use('kevinhwang91/nvim-bqf') -- Better quickfix window in Neovim, polish old quickfix window.
  use({ 'https://gitlab.com/yorickpeterse/nvim-pqf', as = 'nvim-pqf' }) -- Prettier quickfix/location list windows for NeoVim

  -- Registers
  use('tversteeg/registers.nvim') -- Neovim plugin to preview the contents of the registers

  -- Movement
  use({
    {
      'ggandor/leap.nvim', -- Neovim's answer to the mouse: a "clairvoyant" interface that makes on-screen jumps quicker and more natural than ever
      requires = 'tpope/vim-repeat', -- enable repeating supported plugin maps with "."
    },
    'ggandor/flit.nvim', -- Enhanced f/t motions for Leap
    'ggandor/leap-ast.nvim' -- Jump to, select and operate on AST nodes via the Leap interface with Treesitter (WIP)
  })

  -- Search / Easy VAX-like find
  use({
    {
      'nvim-telescope/telescope.nvim', -- Find, Filter, Preview, Pick. All lua, all the time.
      requires = {
        'nvim-lua/popup.nvim',
        'nvim-lua/plenary.nvim',
        'nvim-telescope/telescope-frecency.nvim',
        'nvim-telescope/telescope-fzf-native.nvim',
        'nvim-telescope/telescope-ui-select.nvim', -- It sets vim.ui.select to telescope.
      },
      -- cmd = 'Telescope', -- Specifies commands which load this plugin. Can be an autocmd pattern.
    },
    {
      'nvim-telescope/telescope-frecency.nvim', -- A telescope.nvim extension that offers intelligent prioritization when selecting files from your editing history.
      -- after = 'telescope.nvim',
      requires = 'kkharji/sqlite.lua', -- SQLite LuaJIT binding with a very simple api.
    },
    {
      'nvim-telescope/telescope-fzf-native.nvim', -- FZF sorter for telescope written in c
      run = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build',
      -- run = 'make',
    },
    'crispgm/telescope-heading.nvim', -- An extension for telescope.nvim that allows you to switch between headings
    'nvim-telescope/telescope-file-browser.nvim', -- File Browser extension for telescope.nvim
    'nvim-telescope/telescope-live-grep-args.nvim', -- Live grep with args
    'nvim-pack/nvim-spectre', -- Find the enemy and replace them with dark power.
  })

  -- Project
  use('ahmedkhalf/project.nvim')

  -- Indentation tracking
  use('lukas-reineke/indent-blankline.nvim') -- Indent guides for Neovim

  -- Commenting
  use('numToStr/Comment.nvim') -- Smart and powerful comment plugin for neovim

  -- Wrapping/delimiters
  use({
    {'machakann/vim-sandwich'}, -- Set of operators and textobjects to search/select/edit sandwiched texts.
    {'andymass/vim-matchup'},
    'andrewferrier/wrapping.nvim', -- Plugin to make it easier to switch between 'soft' and 'hard' line wrapping in NeoVim
  })

  -- Code
  use('RRethy/vim-illuminate') -- automatically highlighting other uses of the word under the cursor using either LSP, Tree-sitter, or regex matching.
  use('windwp/nvim-autopairs') -- autopairs for neovim written by lua
  use('NMAC427/guess-indent.nvim') -- Automatic indentation style detection for Neovim
  use('norcalli/nvim-colorizer.lua') -- The fastest Neovim colorizer.
  use('ray-x/lsp_signature.nvim') -- LSP signature hint as you type
  use('folke/trouble.nvim') -- 🚦 A pretty diagnostics, references, telescope results, quickfix and location list to help you solve all the trouble your code is causing.
  -- use('ericcurtin/CurtineIncSw.vim') -- Switch from *.c* to *.h* and vice versa
  -- use({
  --   'jakemason/ouroboros.nvim',
  --   requires = { { 'nvim-lua/plenary.nvim' } },
  -- }) -- Allows quickly switching between header and implementation files for C/C++ in Neovim.

  -- Prettification
  use('junegunn/vim-easy-align') -- A Vim alignment plugin

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
  use('PaterJason/cmp-conjure') -- nvim-cmp source for conjure.
  use('hrsh7th/cmp-calc') -- nvim-cmp source for math calculation
  use('hrsh7th/cmp-vsnip') -- nvim-cmp source for vim-vsnip

  -- Snippets
  use('L3MON4D3/LuaSnip')
  use('rafamadriz/friendly-snippets')

  -- Git
  use('lewis6991/gitsigns.nvim') -- Git integration for buffers
  use({ 'TimUntersberger/neogit', requires = 'nvim-lua/plenary.nvim' }) -- A work-in-progress Magit clone for Neovim that is geared toward the Vim philosophy.

  -- Terminal
  use('akinsho/toggleterm.nvim')

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end
end

local plugins = setmetatable({}, {
  __index = function(_, key)
    init()
    return packer[key]
  end,
})

plugins.packer_dir = packer_dir
plugins.ensure_packer = ensure_packer

return plugins
