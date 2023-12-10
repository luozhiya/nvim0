local M = {}

local list = {
  -- Neovim Lua Library
  { 'nvim-lua/plenary.nvim' },
  -- Start Screen
  { 'goolord/alpha-nvim' },
  -- Columns And Lines
  { 'Bekaboo/dropbar.nvim' },
  { 'b0o/incline.nvim' },
  { 'nvim-lualine/lualine.nvim' },
  { 'archibate/lualine-time' },
  -- Colorschemes
  { 'folke/tokyonight.nvim' },
  -- Builtin UI Improved (notify/input/select/quick/messages/popup)
  { 'stevearc/dressing.nvim' },
  { 'folke/noice.nvim' },
  -- File Explorer
  { 'nvim-neo-tree/neo-tree.nvim' },
  -- Window Management
  { 'mrjones2014/smart-splits.nvim' },
  -- Project
  { 'ahmedkhalf/project.nvim' },
  -- Session
  { 'folke/persistence.nvim' },
  -- Fuzzy Finder
  { 'nvim-telescope/telescope.nvim' },
  { 'nvim-telescope/telescope-live-grep-args.nvim' },
  { 'nvim-telescope/telescope-ui-select.nvim' },
  -- Bindings
  { 'folke/which-key.nvim' },
  -- Buffer
  { 'kazhala/close-buffers.nvim' },
  { 'moll/vim-bbye' },
  -- Mini Family
  { 'echasnovski/mini.align' },
  { 'echasnovski/mini.bufremove' },
  { 'echasnovski/mini.pairs' },
  { 'echasnovski/mini.surround' },
  -- Sematic Structure
  { 'nvim-treesitter/nvim-treesitter' },
  { 'nvim-treesitter/playground' },
  -- Matching
  { 'andymass/vim-matchup' },
  -- Surround
  { 'kylechui/nvim-surround' },
  -- Indent
  { 'lukas-reineke/indent-blankline.nvim' },
  -- Alignment
  { 'junegunn/vim-easy-align' },
  { 'RRethy/nvim-align' },
  -- Formatting
  { 'mhartington/formatter.nvim' },
  -- Visual Enchanced
  { 'HiPhish/rainbow-delimiters.nvim' },
  -- Comment
  { 'numToStr/Comment.nvim' },
  -- Todo
  { 'folke/todo-comments.nvim' },
  -- Completion
  { 'hrsh7th/nvim-cmp' },
  { 'hrsh7th/cmp-cmdline' },
  { 'hrsh7th/cmp-path' },
  { 'hrsh7th/cmp-nvim-lsp' },
  { 'hrsh7th/cmp-buffer' },
  { 'hrsh7th/cmp-emoji' },
  { 'onsails/lspkind.nvim' },
  -- C++
  { 'p00f/godbolt.nvim' },
  -- Diagnostics
  { 'folke/trouble.nvim' },
  -- LSP
  { 'neovim/nvim-lspconfig' },
  { 'p00f/clangd_extensions.nvim' },
  -- Storage
  { 'kkharji/sqlite.lua' },
}

local cached = {}
M.computed = function()
  if vim.tbl_isempty(cached) then
    local spec = require('module.settings').spec
    for i, v in ipairs(list) do
      cached[i] = spec(v)
    end
  end
  return cached
end

return M
