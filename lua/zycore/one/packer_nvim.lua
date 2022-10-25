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

-- Manager
-- Setup
-- Load
-- Config
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

  -- Core
  -- Coding
  -- Move
  -- UI
  -- Extern

  -- System
  use({
    'nvim-lua/plenary.nvim', -- Note that this library is useless outside of Neovim since it requires Neovim functions.
    'lewis6991/impatient.nvim', -- Improve startup time for Neovim
  })

  -- Packer
  use('wbthomason/packer.nvim')

  -- Fennel
  use({
    'Olical/aniseed', -- Neovim configuration and plugins in Fennel (Lisp compiled to Lua)
    'Olical/conjure', -- Interactive evaluation for Neovim (Clojure, Fennel, Janet, Racket, Hy, MIT Scheme, Guile)
    -- 'rktjmp/hotpot.nvim', -- Carl Weathers #1 Neovim Plugin.
  })

  -- LSP
  use({
    { 
      'neovim/nvim-lspconfig', -- Configurations for Nvim LSP
      -- after = {
      --   'cmp-nvim-lsp',
      --   'nvim-lsp-installer',
      -- },
      config = [[require('zycore.one.lsp')]],
    },
    'williamboman/nvim-lsp-installer', -- Simple to install LSP servers
    {
      'https://git.sr.ht/~whynothugo/lsp_lines.nvim', -- Show nvim diagnostics using virtual lines
      as = 'lsp_lines.nvim',
    },
    'nvim-lua/lsp-status.nvim', -- Utility functions for getting diagnostic status and progress messages from LSP servers, for use in the Neovim statusline
    'j-hui/fidget.nvim', -- Standalone UI for nvim-lsp progress
    'kosayoda/nvim-lightbulb', -- VSCode 💡 for neovim's built-in LSP.
    'ray-x/lsp_signature.nvim', -- LSP signature hint as you type
    'stevearc/aerial.nvim', -- Neovim plugin for a code outline window
    'jose-elias-alvarez/null-ls.nvim', -- Inject LSP diagnostics, code actions, and more via Lua
  })

  -- Completion
  use({
    'hrsh7th/nvim-cmp', -- Autocompletion plugin
    requires = {
      { 'hrsh7th/cmp-nvim-lsp', after = 'nvim-cmp' }, -- LSP source for nvim-cmp
      { 'hrsh7th/cmp-buffer', after = 'nvim-cmp' },
      { 'hrsh7th/cmp-path', after = 'nvim-cmp' },
      { 'hrsh7th/cmp-nvim-lua', after = 'nvim-cmp' },
      { 'hrsh7th/cmp-calc', after = 'nvim-cmp' },
      { 'hrsh7th/cmp-vsnip', after = 'nvim-cmp' }, -- nvim-cmp source for vim-vsnip
      { 'hrsh7th/cmp-nvim-lsp-signature-help', after = 'nvim-cmp' },
      { 'hrsh7th/cmp-nvim-lsp-document-symbol', after = 'nvim-cmp' },
      { 'hrsh7th/cmp-cmdline', after = 'nvim-cmp' },
      { 'lukas-reineke/cmp-under-comparator' },
      { 'saadparwaiz1/cmp_luasnip' },
      { 'onsails/lspkind.nvim' }, -- vscode-like pictograms for neovim lsp completion items
      { 'PaterJason/cmp-conjure', after = 'nvim-cmp' }, -- nvim-cmp source for conjure.
    },
    config = [[require('zycore.one.cmp')]],
    event = 'InsertEnter',
  })

  -- C++
  use({
    'm-pilia/vim-ccls', -- supports some additional methods provided by ccls, which are not part of the standard Language Server Protocol (LSP)
    'jackguo380/vim-lsp-cxx-highlight', -- semantic highlighting using the language server protocol.
    { 
      'p00f/clangd_extensions.nvim', -- Clangd's off-spec features for neovim's LSP client.
      after = 'cmp-nvim-lsp',
      config = [[require('zycore.one.clangd_extensions')]],
    },
  })
  -- use('ericcurtin/CurtineIncSw.vim') -- Switch from *.c* to *.h* and vice versa
  -- use({
  --   'jakemason/ouroboros.nvim',
  --   requires = { { 'nvim-lua/plenary.nvim' } },
  -- }) -- Allows quickly switching between header and implementation files for C/C++ in Neovim.

  -- Lua
  use({
    { 'folke/lua-dev.nvim', after = 'nvim-lspconfig', }, -- Dev setup for init.lua and plugin development with full signature help, docs and completion for the nvim lua API.
    'jbyuki/one-small-step-for-vimkind', -- Debug adapter for Neovim plugins
  })

  -- Debugging
  use({
    'mfussenegger/nvim-dap',
    'rcarriga/nvim-dap-ui',
    'theHamsta/nvim-dap-virtual-text',
    'folke/trouble.nvim', -- 🚦 A pretty diagnostics, references, telescope results, quickfix and location list to help you solve all the trouble your code is causing.
  })

  -- Highlights/treesitter
  use({
    {
      'nvim-treesitter/nvim-treesitter', -- Nvim Treesitter configurations and abstraction layer
      requires = {
        'nvim-treesitter/nvim-treesitter-refactor',
        'RRethy/nvim-treesitter-textsubjects',
      },
      run = ':TSUpdate',
    },
    'JoosepAlviste/nvim-ts-context-commentstring', -- Neovim treesitter plugin for setting the commentstring based on the cursor location in a file.
    'p00f/nvim-ts-rainbow', -- Rainbow parentheses for neovim using tree-sitter.
    'nvim-treesitter/nvim-treesitter-textobjects', -- Syntax aware text-objects, select, move, swap, and peek support.
    'RRethy/nvim-treesitter-endwise', -- Wisely add "end" in Ruby, Vimscript, Lua, etc. Tree-sitter aware alternative to tpope's vim-endwise
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
      setup = [[require('zycore.one.telescope_setup')]], -- Specifies code to run before this plugin is loaded.
      config = [[require('zycore.one.telescope')]], -- Specifies code to run after this plugin is loaded.
      cmd = 'Telescope', -- Specifies commands which load this plugin. Can be an autocmd pattern.
      module = 'telescope', -- Specifies Lua module names for require.
    },
    {
      'nvim-telescope/telescope-frecency.nvim', -- A telescope.nvim extension that offers intelligent prioritization when selecting files from your editing history.
      after = 'telescope.nvim', -- module name, not github short path
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

  -- Buffer
  use({
    'moll/vim-bbye', -- Delete buffers and close files in Vim without closing your windows or messing up your layout.
    'kazhala/close-buffers.nvim', -- 📑 Delete multiple vim buffers based on different conditions
  })

  -- Registers
  use('tversteeg/registers.nvim') -- Neovim plugin to preview the contents of the registers

  -- Indentation tracking
  use({
    'lukas-reineke/indent-blankline.nvim', -- Indent guides for Neovim
    'NMAC427/guess-indent.nvim', -- Automatic indentation style detection for Neovim
  })

  -- Format
  use({
    'sbdchd/neoformat', -- why not use .clang-format?
    'rhysd/vim-clang-format',
    'cappyzawa/trim.nvim', -- trims trailing whitespace and lines
    'mhartington/formatter.nvim', -- A format runner for Neovim.
    'lukas-reineke/lsp-format.nvim', -- A wrapper around Neovims native LSP formatting.
  })

  -- Prettification
  use('junegunn/vim-easy-align') -- A Vim alignment plugin

  -- Commenting
  use({
    'numToStr/Comment.nvim', -- Smart and powerful comment plugin for neovim
    -- config = [[require('zycore.one.comment')]],
    -- event = 'User ActuallyEditing',
  })

  -- Snippets
  use({
    'L3MON4D3/LuaSnip',
    'rafamadriz/friendly-snippets',
  })

  -- Wrapping/delimiters
  use({
    {
      'machakann/vim-sandwich', -- Set of operators and textobjects to search/select/edit sandwiched texts.
      event = 'User ActuallyEditing',
    },
    {
      'andymass/vim-matchup',
      config = [[require('zycore.one.matchup')]],
      event = 'User ActuallyEditing',
    },
    'monkoose/matchparen.nvim', -- alternative to default neovim matchparen plugin
    'andrewferrier/wrapping.nvim', -- Plugin to make it easier to switch between 'soft' and 'hard' line wrapping in NeoVim
  })

  -- Pair
  use({
    'windwp/nvim-autopairs', -- autopairs for neovim written by lua
    after = 'nvim-cmp',
    config = [[require('zycore.one.nvim_autopairs')]],
  })

  -- Code Visual Improved
  use({
    'RRethy/vim-illuminate', -- automatically highlighting other uses of the word under the cursor using either LSP, Tree-sitter, or regex matching.
    'norcalli/nvim-colorizer.lua', -- The fastest Neovim colorizer.
  })

  -- Keyboard
  use('folke/which-key.nvim')

  -- Movement
  use({
    {
      'ggandor/leap.nvim', -- Neovim's answer to the mouse: a "clairvoyant" interface that makes on-screen jumps quicker and more natural than ever
      requires = 'tpope/vim-repeat', -- enable repeating supported plugin maps with "."
    },
    'ggandor/flit.nvim', -- Enhanced f/t motions for Leap
    'ggandor/leap-ast.nvim', -- Jump to, select and operate on AST nodes via the Leap interface with Treesitter (WIP)
  })

  -- Quickfix
  use({
    {
      'Olical/vim-enmasse', -- Edit every line in a quickfix list at the same time
      cmd = 'EnMasse',
    },
    'kevinhwang91/nvim-bqf', -- Better quickfix window in Neovim, polish old quickfix window.
    {
      'https://gitlab.com/yorickpeterse/nvim-pqf', -- Prettier quickfix/location list windows for NeoVim
      as = 'nvim-pqf',
    },
  })

  -- Undo tree
  use({
    'mbbill/undotree',
    cmd = 'UndotreeToggle',
    config = [[vim.g.undotree_SetFocusWhenToggle = 1]],
  })

  -- Project Management/Sessions
  use('ahmedkhalf/project.nvim')

  -- Pretty symbols
  use('kyazdani42/nvim-web-devicons')

  -- UI/File tree/Status/Tab
  use({
    'delphinus/dwm.nvim', -- Tiled Window Management
    'goolord/alpha-nvim', -- a lua powered greeter like vim-startify / dashboard-nvim
    'kyazdani42/nvim-tree.lua', -- A file explorer tree for neovim written in lua
    'nvim-lualine/lualine.nvim', -- A blazing fast and easy to configure neovim statusline plugin written in pure lua.
    -- 'akinsho/bufferline.nvim', -- A snazzy bufferline for Neovim
    'luozhiya/bufferline.nvim',
    'rcarriga/nvim-notify', -- A fancy, configurable, notification manager for NeoVim
    'Pocco81/true-zen.nvim', -- Clean and elegant distraction-free writing for NeoVim
  })

  -- Colorscheme
  use({
    -- 'Mofiqul/vscode.nvim', -- VSCode dark theme
    -- 'lunarvim/darkplus.nvim',
    'luozhiya/darkplus.nvim',
    'luozhiya/omegadark.nvim',
  })

  -- Git
  use({
    {
      'lewis6991/gitsigns.nvim', -- Git integration for buffers
      requires = 'nvim-lua/plenary.nvim',
      config = [[require('zycore.one.gitsigns')]],
      event = 'User ActuallyEditing',
    },
    {
      'TimUntersberger/neogit', -- A work-in-progress Magit clone for Neovim that is geared toward the Vim philosophy.
      requires = 'nvim-lua/plenary.nvim',
      cmd = 'Neogit',
      config = [[require('zycore.one.neogit_nvim')]],
    },
    {
      'akinsho/git-conflict.nvim', -- A plugin to visualise and resolve merge conflicts in neovim
      tag = '*',
      config = [[require('zycore.one.git_conflict')]],
    },
  })

  -- Terminal
  use('akinsho/toggleterm.nvim')
end

-- Automatically compile after packer_nvim.lua modified.
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost packer_nvim.lua source <afile> | PackerCompile
  augroup end
]])

local plugins = setmetatable({}, {
  __index = function(_, key)
    init()
    return packer[key]
  end,
})

plugins.packer_dir = packer_dir
plugins.ensure_packer = ensure_packer

return plugins
