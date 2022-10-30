local nvim_tree = require('nvim-tree')
local tree_cb = require('nvim-tree.config').nvim_tree_callback

vim.cmd([[
" hi NvimTreeWinSeparator guifg=black guibg=black
" hi NvimTreeStatusLineNC ctermbg=black ctermfg=black
" hi NvimTreeStatusLine ctermbg=black ctermfg=black
]])

local opts = {
  update_focused_file = {
    enable = true,
    update_cwd = true,
  },
  renderer = {
    root_folder_modifier = ':t',
    icons = {
      glyphs = {
        default = '',
        symlink = '',
        folder = {
          arrow_open = '',
          arrow_closed = '',
          default = '',
          open = '',
          empty = '',
          empty_open = '',
          symlink = '',
          symlink_open = '',
        },
        git = {
          unstaged = '',
          staged = 'S',
          unmerged = '',
          renamed = '➜',
          untracked = 'U',
          deleted = '',
          ignored = '◌',
        },
      },
    },
  },
  diagnostics = {
    enable = false,
    show_on_dirs = true,
    icons = {
      hint = '',
      info = '',
      warning = '',
      error = '',
    },
  },
  view = {
    adaptive_size = false,
    side = 'left',
    preserve_window_proportions = true,
    mappings = {
      list = {
        { key = { 'l', '<CR>', 'o' }, cb = tree_cb('edit') },
        { key = 'h', cb = tree_cb('close_node') },
        { key = 'v', cb = tree_cb('vsplit') },
      },
    },
  },
  actions = {
    open_file = {
      resize_window = false,
    },
  },
  filters = {
    dotfiles = false,
    custom = { '^\\.git' },
    exclude = {},
  },
  git = {
    ignore = false,
  },
}

nvim_tree.setup(opts)
