local fn = vim.fn

local hardworking = require('zycore.base.hardworking')
local config = hardworking.config_path
local packpath = hardworking.packpath
local package_root = hardworking.package_root

local packer_dir = package_root .. '/packer'
local install_path = packer_dir .. '/start/packer.nvim'
local compile_path = config .. '/plugin/packer_compiled.lua'

-- vim.cmd([[packadd nvim-cmp]])

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

  -- Profiling
  -- use({ 'dstein64/vim-startuptime', cmd = 'StartupTime', config = [[vim.g.startuptime_tries = 10]] })
  use({ 'dstein64/vim-startuptime', config = [[vim.g.startuptime_tries = 10]] })

  -- Packer
  use('wbthomason/packer.nvim')

  -- Fennel
  -- use({
  --   'Olical/aniseed', -- Neovim configuration and plugins in Fennel (Lisp compiled to Lua)
  --   requires = {
  --     { 'Olical/conjure', event = 'InsertEnter' }, -- Interactive evaluation for Neovim (Clojure, Fennel, Janet, Racket, Hy, MIT Scheme, Guile)
  --   },
  --   -- 'rktjmp/hotpot.nvim', -- Carl Weathers #1 Neovim Plugin.
  -- })
  use('Olical/aniseed')
  use('Olical/conjure')

  -- Lua
  -- use({
  --   'folke/neodev.nvim', -- Dev setup for init.lua and plugin development with full signature help, docs and completion for the nvim lua API.
  --   config = [[require('zycore.one.neodev')]],
  --   -- event = 'InsertEnter', -- always enable neodev.nvim
  -- })
  use({ 'folke/neodev.nvim', config = [[require('zycore.one.neodev')]] })

  -- LSP
  -- use({
  --   {
  --     'neovim/nvim-lspconfig', -- Configurations for Nvim LSP
  --     -- requires = {
  --     --   { 'folke/neodev.nvim' },
  --     -- },
  --     -- after = {
  --     --   'cmp-nvim-lsp',
  --     --   'neodev.nvim',
  --     -- },
  --     config = [[require('zycore.one.lsp.handler').setup()]],
  --     -- event = 'InsertEnter',
  --   },
  --   { 'williamboman/nvim-lsp-installer', after = 'nvim-lspconfig', config = [[require('zycore.one.lsp.config_servers')]] }, -- Simple to install LSP servers
  --   {
  --     'https://git.sr.ht/~whynothugo/lsp_lines.nvim', -- Show nvim diagnostics using virtual lines
  --     as = 'lsp_lines.nvim',
  --     after = 'nvim-lspconfig',
  --     config = [[require('zycore.one.lsp_lines_nvim')]],
  --     disable = true,
  --   },
  --   { 'nvim-lua/lsp-status.nvim', after = 'nvim-lspconfig' }, -- Utility functions for getting diagnostic status and progress messages from LSP servers, for use in the Neovim statusline
  --   { 'j-hui/fidget.nvim', after = 'nvim-lspconfig', config = [[require('zycore.one.fidget_nvim')]] }, -- Standalone UI for nvim-lsp progress
  --   { 'kosayoda/nvim-lightbulb', after = 'nvim-lspconfig', config = [[require('zycore.one.nvim_lightbulb')]] }, -- VSCode 💡 for neovim's built-in LSP.
  --   { 'ray-x/lsp_signature.nvim', after = 'nvim-lspconfig', config = [[require('zycore.one.lsp_signature_nvim')]] }, -- LSP signature hint as you type
  --   { 'stevearc/aerial.nvim', after = 'nvim-lspconfig', config = [[require('zycore.one.aerial')]] }, -- Neovim plugin for a code outline window
  --   { 'jose-elias-alvarez/null-ls.nvim', after = 'nvim-lspconfig', config = [[require('zycore.one.null_ls')]] }, -- Inject LSP diagnostics, code actions, and more via Lua
  --   { 'glepnir/lspsaga.nvim', after = 'nvim-lspconfig', config = [[require('zycore.one.lspsaga')]] }, -- A light-weight lsp plugin based on neovim's built-in lsp with a highly performant UI.
  -- })
  use({ 'neovim/nvim-lspconfig', config = [[require('zycore.one.lsp.config_servers')]] })
  use({ 'williamboman/nvim-lsp-installer' })
  use('nvim-lua/lsp-status.nvim')
  use({ 'j-hui/fidget.nvim', config = [[require('zycore.one.fidget_nvim')]] })
  use({ 'kosayoda/nvim-lightbulb', config = [[require('zycore.one.nvim_lightbulb')]] })
  use({ 'ray-x/lsp_signature.nvim', config = [[require('zycore.one.lsp_signature_nvim')]] })
  use({ 'stevearc/aerial.nvim', config = [[require('zycore.one.aerial')]] })
  use({ 'jose-elias-alvarez/null-ls.nvim', config = [[require('zycore.one.null_ls')]] })
  use({ 'glepnir/lspsaga.nvim', config = [[require('zycore.one.lspsaga')]] })

  -- Completion
  -- use({
  --   {
  --     'hrsh7th/nvim-cmp', -- Autocompletion plugin
  --     config = [[require('zycore.one.cmp_lite')]],
  --     -- module = 'cmp',
  --     -- event = 'InsertEnter',
  --     -- after = { 'cmp-under-comparator', 'clangd_extensions.nvim', 'lspkind.nvim', 'conjure' },
  --   },
  --   { 'hrsh7th/cmp-nvim-lsp' }, -- LSP source for nvim-cmp
  --   { 'hrsh7th/cmp-buffer', after = 'nvim-cmp' },
  --   { 'hrsh7th/cmp-path', after = 'nvim-cmp' },
  --   { 'hrsh7th/cmp-nvim-lua', event = 'InsertEnter', after = 'nvim-cmp' },
  --   { 'hrsh7th/cmp-calc', after = 'nvim-cmp' },
  --   { 'hrsh7th/cmp-vsnip', event = 'InsertEnter', after = 'nvim-cmp' }, -- nvim-cmp source for vim-vsnip
  --   { 'hrsh7th/cmp-nvim-lsp-signature-help', event = 'InsertEnter', after = 'nvim-cmp' },
  --   { 'hrsh7th/cmp-nvim-lsp-document-symbol', event = 'InsertEnter', after = 'nvim-cmp' },
  --   { 'hrsh7th/cmp-cmdline', after = 'nvim-cmp', disable = false },
  --   { 'lukas-reineke/cmp-under-comparator', event = 'InsertEnter', event = 'InsertEnter' },
  --   { 'saadparwaiz1/cmp_luasnip', event = 'InsertEnter', after = 'nvim-cmp' },
  --   { 'onsails/lspkind.nvim' }, -- vscode-like pictograms for neovim lsp completion items
  --   { 'PaterJason/cmp-conjure', event = 'InsertEnter', after = { 'nvim-cmp', 'conjure' }, event = 'InsertEnter' }, -- nvim-cmp source for conjure.
  -- })
  use({ 'hrsh7th/nvim-cmp', config = [[require('zycore.one.cmp')]] })
  use('hrsh7th/cmp-nvim-lsp')
  use('hrsh7th/cmp-buffer')
  use('hrsh7th/cmp-path')
  use('hrsh7th/cmp-nvim-lua')
  use('hrsh7th/cmp-calc')
  use('hrsh7th/cmp-vsnip')
  use('hrsh7th/cmp-nvim-lsp-signature-help')
  use('hrsh7th/cmp-nvim-lsp-document-symbol')
  use('hrsh7th/cmp-cmdline')
  use('lukas-reineke/cmp-under-comparator')
  use('saadparwaiz1/cmp_luasnip')
  use('onsails/lspkind.nvim')
  use('PaterJason/cmp-conjure')

  -- C++
  -- use({
  --   { 'm-pilia/vim-ccls', after = 'nvim-lspconfig' }, -- supports some additional methods provided by ccls, which are not part of the standard Language Server Protocol (LSP)
  --   { 'jackguo380/vim-lsp-cxx-highlight', after = 'nvim-lspconfig' }, -- semantic highlighting using the language server protocol.
  --   {
  --     -- cycle references
  --     -- clangd -> lsp -> cmp-nvim
  --     'p00f/clangd_extensions.nvim', -- Clangd's off-spec features for neovim's LSP client.
  --     after = {
  --       'cmp-nvim-lsp',
  --       'nvim-lspconfig',
  --       'nvim-lsp-installer',
  --     },
  --     event = 'InsertEnter',
  --     config = [[require('zycore.one.clangd_extensions')]],
  --   },
  -- })
  -- use('ericcurtin/CurtineIncSw.vim') -- Switch from *.c* to *.h* and vice versa
  -- use({
  --   'jakemason/ouroboros.nvim',
  --   requires = { { 'nvim-lua/plenary.nvim' } },
  -- }) -- Allows quickly switching between header and implementation files for C/C++ in Neovim.
  use('m-pilia/vim-ccls')
  use('jackguo380/vim-lsp-cxx-highlight')
  use({ 'p00f/clangd_extensions.nvim', config = [[require('zycore.one.clangd_extensions')]] })

  -- Debugging
  -- use({
  --   {
  --     'mfussenegger/nvim-dap',
  --     requires = {
  --       { 'jbyuki/one-small-step-for-vimkind', after = 'nvim-dap' }, -- Debug adapter for Neovim plugins
  --       { 'theHamsta/nvim-dap-virtual-text', after = 'nvim-dap', config = [[require('zycore.one.dap-virtual-text')]] },
  --     },
  --     config = [[require('zycore.one.dap')]],
  --     -- event = 'InsertEnter',
  --     -- cmd = { 'BreakpointToggle', 'Debug', 'DapREPL' },
  --   },
  --   {
  --     'Weissle/persistent-breakpoints.nvim',
  --     config = [[require('zycore.one.dap-persistent-breakpoints')]],
  --   },
  --   {
  --     'rcarriga/nvim-dap-ui',
  --     after = 'nvim-dap',
  --     config = [[require('zycore.one.dapui')]],
  --   },
  --   {
  --     'folke/trouble.nvim', -- 🚦 A pretty diagnostics, references, telescope results, quickfix and location list to help you solve all the trouble your code is causing.
  --     setup = [[require('zycore.one.trouble_setup')]],
  --     config = [[require('zycore.one.trouble')]],
  --     cmd = 'TroubleToggle',
  --   },
  -- })
  use({ 'mfussenegger/nvim-dap', config = [[require('zycore.one.dap')]] })
  use({ 'theHamsta/nvim-dap-virtual-text', config = [[require('zycore.one.dap-virtual-text')]] })
  use('jbyuki/one-small-step-for-vimkind')
  use({ 'Weissle/persistent-breakpoints.nvim', config = [[require('zycore.one.dap-persistent-breakpoints')]] })
  use({ 'rcarriga/nvim-dap-ui', config = [[require('zycore.one.dapui')]] })
  use({ 'folke/trouble.nvim', config = [[require('zycore.one.trouble')]] })

  -- Highlights/treesitter
  -- Why buggy?
  -- use({
  --   {
  --     'nvim-treesitter/nvim-treesitter',
  --     run = ':TSUpdate',
  --   },
  -- })
  -- use({
  --   'nvim-treesitter/nvim-treesitter', -- Nvim Treesitter configurations and abstraction layer
  --   requires = {
  --     { 'nvim-treesitter/nvim-treesitter-refactor', after = 'nvim-treesitter' },
  --     { 'RRethy/nvim-treesitter-textsubjects', after = 'nvim-treesitter' },
  --     { 'JoosepAlviste/nvim-ts-context-commentstring', after = 'nvim-treesitter' }, -- Neovim treesitter plugin for setting the commentstring based on the cursor location in a file.
  --     { 'p00f/nvim-ts-rainbow', after = 'nvim-treesitter' }, -- Rainbow parentheses for neovim using tree-sitter.
  --     { 'nvim-treesitter/nvim-treesitter-textobjects', after = 'nvim-treesitter' }, -- Syntax aware text-objects, select, move, swap, and peek support.
  --     { 'RRethy/nvim-treesitter-endwise', after = 'nvim-treesitter' }, -- Wisely add "end" in Ruby, Vimscript, Lua, etc. Tree-sitter aware alternative to tpope's vim-endwise
  --   },
  --   config = [[require('zycore.one.treesitter')]],
  --   run = ':TSUpdate',
  --   event = 'BufReadPost',
  -- })
  use({ 'nvim-treesitter/nvim-treesitter', config = [[require('zycore.one.treesitter')]] })
  use('nvim-treesitter/nvim-treesitter-refactor')
  use('RRethy/nvim-treesitter-textsubjects')
  use('JoosepAlviste/nvim-ts-context-commentstring')
  use('p00f/nvim-ts-rainbow')
  use('nvim-treesitter/nvim-treesitter-textobjects')
  use('RRethy/nvim-treesitter-endwise')

  -- Search / Easy VAX-like find
  -- use({
  --   {
  --     'nvim-telescope/telescope.nvim', -- Find, Filter, Preview, Pick. All lua, all the time.
  --     requires = {
  --       'nvim-lua/popup.nvim',
  --       'nvim-lua/plenary.nvim',
  --       'nvim-telescope/telescope-frecency.nvim',
  --       'nvim-telescope/telescope-fzf-native.nvim',
  --       'nvim-telescope/telescope-ui-select.nvim',
  --       'crispgm/telescope-heading.nvim',
  --       'nvim-telescope/telescope-file-browser.nvim',
  --       'nvim-telescope/telescope-live-grep-args.nvim',
  --     },
  --     setup = [[require('zycore.one.telescope_setup')]], -- Specifies code to run before this plugin is loaded.
  --     -- timeline: setup -> config -> after
  --     config = [[require('zycore.one.telescope')]], -- Specifies code to run after this plugin is loaded.
  --     cmd = 'Telescope', -- Specifies commands which load this plugin. Can be an autocmd pattern.
  --     module = 'telescope', -- Specifies Lua module names for require.
  --   },
  --   {
  --     'nvim-telescope/telescope-frecency.nvim', -- A telescope.nvim extension that offers intelligent prioritization when selecting files from your editing history.
  --     after = { 'telescope.nvim', 'sqlite.lua' }, -- module name, not github short path
  --     requires = {
  --       'kkharji/sqlite.lua', -- SQLite LuaJIT binding with a very simple api.
  --       after = 'telescope.nvim',
  --       config = [[require('zycore.one.sqlite')]],
  --     },
  --     config = [[require('telescope').load_extension('frecency')]],
  --   },
  --   {
  --     'nvim-telescope/telescope-fzf-native.nvim', -- FZF sorter for telescope written in c
  --     after = 'telescope.nvim',
  --     run = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build',
  --     config = [[require('telescope').load_extension('fzf')]],
  --     -- run = 'make',
  --   },
  --   {
  --     'crispgm/telescope-heading.nvim', -- An extension for telescope.nvim that allows you to switch between headings
  --     after = 'telescope.nvim',
  --     config = [[require('telescope').load_extension('heading')]],
  --   },
  --   {
  --     'nvim-telescope/telescope-file-browser.nvim', -- File Browser extension for telescope.nvim
  --     after = 'telescope.nvim', -- ??
  --     config = [[require('telescope').load_extension('file_browser')]],
  --   },
  --   {
  --     'nvim-telescope/telescope-live-grep-args.nvim', -- Live grep with args
  --     after = 'telescope.nvim',
  --     config = [[require('telescope').load_extension('live_grep_args')]],
  --   },
  --   {
  --     'nvim-telescope/telescope-ui-select.nvim', -- It sets vim.ui.select to telescope.
  --     after = 'telescope.nvim',
  --     config = [[require('telescope').load_extension('ui-select')]],
  --   },
  --   {
  --     'nvim-pack/nvim-spectre', -- Find the enemy and replace them with dark power.
  --     event = 'BufReadPost',
  --     config = [[require('zycore.one.nvim_spectre')]],
  --   },
  -- })
  use('nvim-lua/popup.nvim')
  use('nvim-telescope/telescope.nvim')
  use('kkharji/sqlite.lua')
  use('nvim-telescope/telescope-frecency.nvim')
  use({
    'nvim-telescope/telescope-fzf-native.nvim', -- FZF sorter for telescope written in c
    run = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build',
    -- run = 'make',
  })
  use('crispgm/telescope-heading.nvim')
  use('nvim-telescope/telescope-ui-select.nvim')
  use('nvim-telescope/telescope-live-grep-args.nvim')
  use('nvim-telescope/telescope-file-browser.nvim')
  use({ 'nvim-pack/nvim-spectre', config = [[require('zycore.one.nvim_spectre')]] })

  -- Buffer
  -- use({
  --   {
  --     'moll/vim-bbye', -- Delete buffers and close files in Vim without closing your windows or messing up your layout.
  --     config = [[require('zycore.one.vim_bbye')]],
  --     event = 'BufAdd',
  --   },
  --   {
  --     'kazhala/close-buffers.nvim', -- 📑 Delete multiple vim buffers based on different conditions
  --     config = [[require('zycore.one.close_buffer')]],
  --     event = 'BufAdd',
  --   },
  -- })
  use({ 'moll/vim-bbye', config = [[require('zycore.one.vim_bbye')]] })
  use({ 'kazhala/close-buffers.nvim', config = [[require('zycore.one.close_buffer')]] })

  -- Registers
  use('tversteeg/registers.nvim') -- Neovim plugin to preview the contents of the registers

  -- Indentation tracking
  -- use({
  --   {
  --     'lukas-reineke/indent-blankline.nvim', -- Indent guides for Neovim
  --     after = 'nvim-treesitter',
  --     config = [[require('zycore.one.indent_blankline')]],
  --     -- disable = true,
  --   },
  --   {
  --     'NMAC427/guess-indent.nvim', -- Automatic indentation style detection for Neovim
  --     after = 'nvim-treesitter',
  --     config = [[require('zycore.one.guess_indent')]],
  --   },
  -- })
  use({ 'NMAC427/guess-indent.nvim', config = [[require('zycore.one.guess_indent')]] })

  -- Format
  -- use({
  --   {
  --     'sbdchd/neoformat', -- why not use .clang-format?
  --     event = 'BufReadPost',
  --     config = [[require('zycore.one.format').neoformat_setup()]],
  --     disable = true,
  --   },
  --   {
  --     'rhysd/vim-clang-format',
  --     event = 'BufReadPost',
  --     config = [[require('zycore.one.format').vim_clang_format_setup()]],
  --     disable = true,
  --   },
  --   {
  --     'cappyzawa/trim.nvim', -- trims trailing whitespace and lines
  --     event = 'BufReadPost',
  --     config = [[require('zycore.one.trim')]],
  --     disable = true,
  --   },
  --   {
  --     'mhartington/formatter.nvim', -- A format runner for Neovim.
  --     event = 'BufReadPost',
  --     config = [[require('zycore.one.formatter')]],
  --     disable = false,
  --   },
  --   {
  --     'lukas-reineke/lsp-format.nvim', -- A wrapper around Neovims native LSP formatting.
  --     after = 'nvim-lspconfig',
  --     event = 'BufReadPost',
  --     config = [[require('zycore.one.lsp_format')]],
  --     disable = true,
  --   },
  -- })

  -- Prettification
  -- use({
  --   'junegunn/vim-easy-align', -- A Vim alignment plugin
  --   config = [[require('zycore.one.easy_align')]],
  --   event = 'BufReadPost',
  -- })
  use({ 'junegunn/vim-easy-align', config = [[require('zycore.one.easy_align')]] })

  -- Commenting
  -- use({
  --   'numToStr/Comment.nvim', -- Smart and powerful comment plugin for neovim
  --   setup = [[require('zycore.one.comment_setup')]],
  --   config = [[require('zycore.one.comment')]],
  --   event = 'BufReadPost',
  --   -- event = 'User ActuallyEditing', -- doesn't work
  -- })
  use({ 'numToStr/Comment.nvim', config = [[require('zycore.one.comment')]] })

  -- Snippets
  -- use({
  --   { 'L3MON4D3/LuaSnip', after = 'nvim-cmp', event = 'BufReadPost' },
  --   { 'rafamadriz/friendly-snippets', after = 'nvim-cmp' },
  -- })
  use('L3MON4D3/LuaSnip')
  use('rafamadriz/friendly-snippets')

  -- Wrapping/delimiters
  -- use({
  --   {
  --     'machakann/vim-sandwich', -- Set of operators and textobjects to search/select/edit sandwiched texts.
  --     event = 'BufReadPost',
  --     disable = true,
  --   },
  --   {
  --     'andymass/vim-matchup',
  --     config = [[require('zycore.one.matchup')]],
  --     event = 'BufReadPost',
  --     disable = true,
  --   },
  --   {
  --     'monkoose/matchparen.nvim', -- alternative to default neovim matchparen plugin
  --     config = [[require('zycore.one.matchparen_nvim')]],
  --     event = 'BufReadPost',
  --     disable = true,
  --   },
  --   {
  --     'andrewferrier/wrapping.nvim', -- Plugin to make it easier to switch between 'soft' and 'hard' line wrapping in NeoVim
  --     config = [[require('zycore.one.wrapping')]],
  --     event = 'BufReadPost',
  --   },
  -- })
  use({ 'andrewferrier/wrapping.nvim', config = [[require('zycore.one.wrapping')]] })

  -- Pair
  -- use({
  --   'windwp/nvim-autopairs', -- autopairs for neovim written by lua
  --   after = 'nvim-cmp',
  --   config = [[require('zycore.one.nvim_autopairs')]],
  --   disable = true,
  -- })

  -- Code Visual Improved
  -- use({
  --   {
  --     'RRethy/vim-illuminate', -- automatically highlighting other uses of the word under the cursor using either LSP, Tree-sitter, or regex matching.
  --     config = [[require('zycore.one.illuminate')]],
  --     event = 'BufReadPost',
  --   },
  --   {
  --     'norcalli/nvim-colorizer.lua', -- The fastest Neovim colorizer.
  --     ft = { 'css', 'javascript', 'vim', 'html', 'lua' },
  --     config = [[require('zycore.one.colorizer')]],
  --     event = 'BufReadPost',
  --   },
  -- })
  use({ 'RRethy/vim-illuminate', config = [[require('zycore.one.illuminate')]] })
  use({ 'norcalli/nvim-colorizer.lua', config = [[require('zycore.one.colorizer')]] })

  -- Keyboard
  use('folke/which-key.nvim')

  -- Movement
  -- use({
  --   {
  --     'ggandor/leap.nvim', -- Neovim's answer to the mouse: a "clairvoyant" interface that makes on-screen jumps quicker and more natural than ever
  --     config = [[require('zycore.one.leap')]],
  --     requires = 'tpope/vim-repeat', -- enable repeating supported plugin maps with "."
  --   },
  --   { 'ggandor/flit.nvim', disable = false }, -- Enhanced f/t motions for Leap
  --   { 'ggandor/leap-ast.nvim', disable = false }, -- Jump to, select and operate on AST nodes via the Leap interface with Treesitter (WIP)
  -- })
  use({ 'ggandor/leap.nvim', config = [[require('zycore.one.leap')]] })
  use('tpope/vim-repeat')
  use('ggandor/flit.nvim')
  use('ggandor/leap-ast.nvim')

  -- Quickfix
  -- use({
  --   {
  --     'Olical/vim-enmasse', -- Edit every line in a quickfix list at the same time
  --     cmd = 'EnMasse',
  --   },
  --   {
  --     'kevinhwang91/nvim-bqf', -- Better quickfix window in Neovim, polish old quickfix window.
  --     config = [[require('zycore.one.nvim_bqf')]],
  --     event = 'BufReadPost',
  --   },
  --   {
  --     'https://gitlab.com/yorickpeterse/nvim-pqf', -- Prettier quickfix/location list windows for NeoVim
  --     as = 'nvim-pqf',
  --     config = [[require('zycore.one.nvim_pqf')]],
  --     event = 'BufReadPost',
  --   },
  -- })
  use('Olical/vim-enmasse')
  use({ 'kevinhwang91/nvim-bqf', config = [[require('zycore.one.nvim_bqf')]] })
  -- use({
  --   'https://gitlab.com/yorickpeterse/nvim-pqf', -- Prettier quickfix/location list windows for NeoVim
  --   as = 'nvim-pqf',
  --   config = [[require('zycore.one.nvim_pqf')]],
  -- })

  -- Undo tree
  -- use({
  --   'mbbill/undotree',
  --   cmd = 'UndotreeToggle',
  --   config = [[vim.g.undotree_SetFocusWhenToggle = 1]],
  --   disable = true,
  -- })
  use({ 'mbbill/undotree', config = [[vim.g.undotree_SetFocusWhenToggle = 1]] })

  -- Project Management/Sessions
  -- use({
  --   'ahmedkhalf/project.nvim',
  --   -- and | or ?
  --   after = { 'telescope.nvim' },
  --   -- module_pattern = { 'nvim-tree' },
  --   config = [[require('zycore.one.project')]],
  --   -- cmd = { 'NvimTreeToggle', 'Telescope' }, -- dependency
  --   -- disable = true,
  --   event = 'BufReadPost', -- workaround for open-file > nvim-tree
  -- })
  use({ 'ahmedkhalf/project.nvim', config = [[require('zycore.one.project')]] })

  -- Pretty symbols
  use('kyazdani42/nvim-web-devicons')

  -- UI/File tree/Status/Tab
  -- use({
  --   {
  --     'delphinus/dwm.nvim', -- Tiled Window Management
  --     disable = true,
  --   },
  --   'goolord/alpha-nvim', -- a lua powered greeter like vim-startify / dashboard-nvim
  --   {
  --     'kyazdani42/nvim-tree.lua', -- A file explorer tree for neovim written in lua
  --     config = [[require('zycore.one.nvim_tree')]],
  --     cmd = 'NvimTreeToggle',
  --   },
  --   'nvim-lualine/lualine.nvim', -- A blazing fast and easy to configure neovim statusline plugin written in pure lua.
  --   -- 'akinsho/bufferline.nvim', -- A snazzy bufferline for Neovim
  --   'luozhiya/bufferline.nvim',
  --   'rcarriga/nvim-notify', -- A fancy, configurable, notification manager for NeoVim
  --   {
  --     'Pocco81/true-zen.nvim', -- Clean and elegant distraction-free writing for NeoVim
  --     config = [[require('zycore.one.true_zen')]],
  --     event = 'BufReadPost',
  --     disable = true,
  --   },
  --   {
  --     'b0o/incline.nvim', -- Floating statuslines for Neovim
  --     config = [[require('zycore.one.incline')]],
  --     event = 'BufReadPost',
  --     disable = true,
  --   },
  -- })
  use('goolord/alpha-nvim')
  use({ 'kyazdani42/nvim-tree.lua', config = [[require('zycore.one.nvim_tree')]] })
  use('nvim-lualine/lualine.nvim')
  use('luozhiya/bufferline.nvim')
  use('rcarriga/nvim-notify')
  -- use({'Pocco81/true-zen.nvim', config = [[require('zycore.one.true_zen')]]})

  -- Colorscheme
  use({
    -- 'Mofiqul/vscode.nvim', -- VSCode dark theme
    -- 'lunarvim/darkplus.nvim',
    'luozhiya/darkplus.nvim',
    'luozhiya/omegadark.nvim',
  })

  -- Git
  -- use({
  --   {
  --     'lewis6991/gitsigns.nvim', -- Git integration for buffers
  --     requires = 'nvim-lua/plenary.nvim',
  --     config = [[require('zycore.one.gitsigns')]],
  --     event = 'BufReadPost',
  --   },
  --   {
  --     'TimUntersberger/neogit', -- A work-in-progress Magit clone for Neovim that is geared toward the Vim philosophy.
  --     requires = 'nvim-lua/plenary.nvim',
  --     cmd = 'Neogit',
  --     config = [[require('zycore.one.neogit_nvim')]],
  --   },
  --   {
  --     'akinsho/git-conflict.nvim', -- A plugin to visualise and resolve merge conflicts in neovim
  --     tag = '*',
  --     event = 'BufReadPost',
  --     config = [[require('zycore.one.git_conflict')]],
  --   },
  -- })
  use({ 'lewis6991/gitsigns.nvim', config = [[require('zycore.one.gitsigns')]] })
  use({ 'TimUntersberger/neogit', config = [[require('zycore.one.neogit_nvim')]] })
  use({ 'akinsho/git-conflict.nvim', config = [[require('zycore.one.git_conflict')]] })

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
