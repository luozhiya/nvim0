local telescope = require('telescope')
local actions = require('telescope.actions')

local fb_actions = telescope.extensions.file_browser.actions

local opts = {
  defaults = {
    prompt_prefix = ' ',
    -- Buggy
    -- selection_caret = ' ',
    path_display = { 'smart', 'truncate = 3' },
    file_ignore_patterns = {
      'node_modules',
      '.work/.*',
      '.cache/.*',
      '.idea/.*',
      'dist/.*',
      '.git/.*',
    },
    mappings = {
      i = {
        ['<C-n>'] = actions.cycle_history_next,
        ['<C-p>'] = actions.cycle_history_prev,

        ['<C-j>'] = actions.move_selection_next,
        ['<C-k>'] = actions.move_selection_previous,

        ['<C-c>'] = actions.close,

        ['<Down>'] = actions.move_selection_next,
        ['<Up>'] = actions.move_selection_previous,

        ['<CR>'] = actions.select_default,
        ['<C-x>'] = actions.select_horizontal,
        ['<C-v>'] = actions.select_vertical,
        ['<C-t>'] = actions.select_tab,

        ['<C-u>'] = actions.preview_scrolling_up,
        ['<C-d>'] = actions.preview_scrolling_down,

        ['<PageUp>'] = actions.results_scrolling_up,
        ['<PageDown>'] = actions.results_scrolling_down,

        ['<Tab>'] = actions.toggle_selection + actions.move_selection_worse,
        ['<S-Tab>'] = actions.toggle_selection + actions.move_selection_better,
        ['<C-q>'] = actions.send_to_qflist + actions.open_qflist,
        ['<M-q>'] = actions.send_selected_to_qflist + actions.open_qflist,
        ['<C-l>'] = actions.complete_tag,
        ['<C-_>'] = actions.which_key, -- keys from pressing <C-/>
      },
      n = {
        ['<esc>'] = actions.close,
        ['<CR>'] = actions.select_default,
        ['<C-x>'] = actions.select_horizontal,
        ['<C-v>'] = actions.select_vertical,
        ['<C-t>'] = actions.select_tab,

        ['<Tab>'] = actions.toggle_selection + actions.move_selection_worse,
        ['<S-Tab>'] = actions.toggle_selection + actions.move_selection_better,
        ['<C-q>'] = actions.send_to_qflist + actions.open_qflist,
        ['<M-q>'] = actions.send_selected_to_qflist + actions.open_qflist,

        ['j'] = actions.move_selection_next,
        ['k'] = actions.move_selection_previous,
        ['H'] = actions.move_to_top,
        ['M'] = actions.move_to_middle,
        ['L'] = actions.move_to_bottom,

        ['<Down>'] = actions.move_selection_next,
        ['<Up>'] = actions.move_selection_previous,
        ['gg'] = actions.move_to_top,
        ['G'] = actions.move_to_bottom,

        ['<C-u>'] = actions.preview_scrolling_up,
        ['<C-d>'] = actions.preview_scrolling_down,

        ['<PageUp>'] = actions.results_scrolling_up,
        ['<PageDown>'] = actions.results_scrolling_down,

        ['?'] = actions.which_key,
      },
    },
  },
  pickers = {
    -- Default configuration for builtin pickers goes here:
    -- picker_name = {
    --   picker_config_key = value,
    --   ...
    -- }
    -- Now the picker_config_key will be applied every time you call this
    -- builtin picker

    find_files = {
      find_command = { 'fd', '--no-ignore', '--type=file', '--hidden', '--exclude=.git/' },
    },
    live_grep = {
      --@usage don't include the filename in the search results
      only_sort_text = true,
    },
    buffers = {
      ignore_current_buffer = false,
      -- sort_mru = true,
      sort_lastused = true,
      previewer = false,
    },
  },
  extensions = {
    -- Your extension configuration goes here:
    -- extension_name = {
    --   extension_config_key = value,
    -- }
    -- please take a look at the readme of the extension you want to configure
    frecency = {
      -- db_root = 'home/luozhiya/Shared/db_root',
      show_scores = false,
      show_unindexed = true,
      ignore_patterns = { '*.git/*', '*/tmp/*' },
      disable_devicons = false,
      workspaces = {
        ['conf'] = '/home/luozhiya/.config',
        ['data'] = '/home/luozhiya/.local/share',
        ['project'] = '/home/luozhiya/Code',
        ['documentation'] = '/home/luozhiya/Code/onWorking/22-09-26-documentation',
      },
    },
    fzy_native = {
      fuzzy = true,
      override_generic_sorter = false,
      override_file_sorter = true,
      case_mode = 'smart_case',
    },
    ['ui-select'] = {
      require('telescope.themes').get_dropdown({ layout_config = { prompt_position = 'top' } }),
    },
    heading = { treesitter = true },
    file_browser = {
      hijack_netwrw = true,
      hidden = true,
      mappings = {
        i = {
          ['<c-n>'] = fb_actions.create,
          ['<c-r>'] = fb_actions.rename,
          ['<c-h>'] = fb_actions.toggle_hidden,
          ['<c-x>'] = fb_actions.remove,
          ['<c-p>'] = fb_actions.move,
          ['<c-y>'] = fb_actions.copy,
          ['<c-a>'] = fb_actions.select_all,
        },
      },
    },
  },
}

telescope.setup(opts)
telescope.load_extension('notify')
telescope.load_extension('frecency')
telescope.load_extension('fzf')
telescope.load_extension('heading')
telescope.load_extension('live_grep_args')
telescope.load_extension('file_browser')
telescope.load_extension('ui-select')

local hardworking = require('zycore.base.hardworking')
local nnoremap = hardworking.nnoremap

-- local map = vim.api.nvim_set_keymap
-- local silent = { silent = true, noremap = true }
-- map('n', '<c-p>', [[<cmd>Telescope buffers show_all_buffers=true theme=get_dropdown<cr>]], silent)
-- map('n', '<c-P>', [[<cmd>Telescope commands theme=get_dropdown<cr>]], silent)

-- ctrl-shfit-p/ctrl-p doesn't work in Windows
-- work in neovide
nnoremap('<c-p>', [[<cmd>Telescope buffers show_all_buffers=true theme=get_dropdown<cr>]])
nnoremap('<c-s-p>', [[<cmd>Telescope commands theme=get_dropdown<cr>]])

nnoremap('<c-a>', [[<cmd>Telescope buffers show_all_buffers=true theme=get_dropdown<cr>]])
nnoremap('<c-e>', [[<cmd>Telescope frecency theme=get_dropdown<cr>]])
nnoremap('<c-s>', [[<cmd>Telescope git_files theme=get_dropdown<cr>]])
nnoremap('<c-d>', [[<cmd>Telescope find_files theme=get_dropdown<cr>]])
-- nnoremap('<c-g>', [[<cmd>Telescope live_grep theme=get_dropdown<cr>]])
nnoremap('<c-g>', [[<cmd>lua require("telescope").extensions.live_grep_args.live_grep_args() theme=get_dropdown<cr>]])
