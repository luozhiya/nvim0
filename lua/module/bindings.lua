local base = require('base')
local M = {}

function M.map(mode, lhs, rhs, opts)
  opts = opts or {}
  if type(opts) == 'string' then
    opts = { desc = opts }
  end
  if opts.silent == nil then
    opts.silent = true
  end
  -- By default, all mappings are nonrecursive by default
  vim.keymap.set(mode, lhs, rhs, opts)
end

function M.command(name, func, opts)
  opts = opts or {}
  if type(opts) == 'string' then
    opts = { desc = opts }
  end
  vim.api.nvim_create_user_command(name, func, opts)
end

function M.cmd(command)
  return table.concat({ '<cmd>', command, '<cr>' })
end

function M.setup_leader()
  vim.g.mapleader = ','
  vim.g.maplocalleader = ','
end

function M.semicolon_to_colon()
  -- M.map('n', ';', ':') -- BUG: don't show ':' sometimes
  vim.cmd([[
    nnoremap ; :
    nnoremap : ;
    vnoremap ; :
    vnoremap : ;
  ]])
end

function M.lsp(client, buffer)
  local function _opts(desc)
    return { buffer = buffer, desc = desc }
  end
  -- stylua: ignore start
  M.map('n', 'gl',    '<cmd>lua vim.diagnostic.open_float({ border = "rounded", max_width = 100 })<cr>', _opts('Line Diagnostics'))
  M.map('n', 'gL',    '<cmd>Lspsaga show_line_diagnostics<cr>',  _opts('Line Diagnostics'))
  M.map('n', 'K',     vim.lsp.buf.hover,                         _opts('Hover'))
  M.map('n', 'gK',    vim.lsp.buf.signature_help,                _opts('Signature Help'))
  M.map('n', 'gn',    vim.lsp.buf.rename,                        _opts('Rename'))
  M.map('n', 'gN',    ':IncRename ',                             _opts('Incremental LSP renaming (inc-rename.nvim)'))
  M.map('n', 'gr',    vim.lsp.buf.references,                    _opts('References'))
  M.map('n', 'gR',    '<cmd>Telescope lsp_references<cr>',       _opts('References'))
  M.map('n', 'gd',    '<cmd>Glance definitions<cr>',             _opts('Goto Definition'))
  M.map('n', 'gD',    '<cmd>Telescope lsp_definitions<cr>',      _opts('Goto Definition'))
  M.map('n', 'gy',    '<cmd>Telescope lsp_type_definitions<cr>', _opts('Goto T[y]pe Definition'))
  M.map('n', 'gi',    vim.lsp.buf.implementation,                _opts('Implementation'))
  M.map('n', 'gI',    '<cmd>Telescope lsp_implementations<cr>',  _opts('Goto Implementation'))
  if client.supports_method('textDocument/codeAction') then
    M.map({ 'n', 'v' }, 'ga', vim.lsp.buf.code_action, _opts('Code Action'))
  end
  if client.supports_method('textDocument/rangeFormatting') then
    M.map('x', '<leader>cf', function() vim.lsp.buf.format({ bufnr = buffer, force = true }) end, _opts('Format Range'))
  end
  if client.supports_method('textDocument/formatting') then
    M.map('n', '<leader>cf', function() vim.lsp.buf.format({ bufnr = buffer, force = true }) end, _opts('Format Document'))
  end
  -- stylua: ignore end
end

function M.alpha()
  local icons = require('module.options').icons.collects
  local button = require('alpha.themes.dashboard').button
  -- stylua: ignore
  return {
    button('f', icons.Search ..         ' Find file',       ':Telescope find_files <cr>'),
    button('n', icons.File ..           ' New file',        ':ene <bar> startinsert <cr>'),
    button('r', icons.Connectdevelop .. ' Recent files',    ':Telescope oldfiles <cr>'),
    button('p', icons.Chrome ..         ' Projects',        ':Projects <cr>'),
    button('g', icons.ListAlt ..        ' Find text',       ':Telescope live_grep <cr>'),
    button('c', icons.Cogs ..           ' Config',          ':e $MYVIMRC <cr>'),
    button('s', icons.IE ..             ' Restore Session', [[:lua require("persistence").load({ last = true }) <cr>]]),
    button('l', icons.Firefox ..        ' Lazy',            ':Lazy<cr>'),
    button('q', icons.Modx ..           ' Quit',            ':qa<cr>'),
  }
end

function M.cmp(cr_selected)
  local cmp = require('cmp')
  local function _forward()
    return cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif require('luasnip').expand_or_jumpable() then
        require('luasnip').expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' })
  end
  local function _backward()
    return cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif require('luasnip').jumpable(-1) then
        require('luasnip').jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' })
  end
  -- stylua: ignore
  return {
    mapping = {
      ['<c-b>']     = cmp.mapping.scroll_docs(-4),
      ['<c-f>']     = cmp.mapping.scroll_docs(4),
      ['<up>']      = cmp.mapping.select_prev_item(),
      ['<down>']    = cmp.mapping.select_next_item(),
      ['<c-o>']     = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }), -- workaround
      ['<tab>']     = _forward(),
      ['<s-tab>']   = _backward(),
      ['<c-e>']     = cmp.mapping({ i = cmp.mapping.abort(), c = cmp.mapping.close() }),
      ['<cr>']      = cmp.mapping.confirm({ select = cr_selected ~= false }),
      ['s-<cr>']    = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    },
  }
end

function M.telescope()
  local actions = require('telescope.actions')
  local action_state = require('telescope.actions.state')
  -- stylua: ignore
  return {
    defaults = {
      mappings = {
        i = {
          ['<c-p>'] = function(prompt_bufnr)
            local selection = action_state.get_current_picker(prompt_bufnr)
            base.copy_to_clipboard(vim.inspect(selection.finder.results))
          end,
          ['<c-n>'] = function(prompt_bufnr)
            local selection = action_state.get_selected_entry()
            base.copy_to_clipboard(vim.inspect(selection))
          end,
          ['<c-t>']    = function(...) return require('trouble.providers.telescope').open_with_trouble(...)          end,
          ['<a-t>']    = function(...) return require('trouble.providers.telescope').open_selected_with_trouble(...) end,
          ['<c-down>'] = function(...) return actions.cycle_history_next(...)                                        end,
          ['<c-up>']   = function(...) return actions.cycle_history_prev(...)                                        end,
          ['<c-f>']    = function(...) return actions.preview_scrolling_down(...)                                    end,
          ['<c-b>']    = function(...) return actions.preview_scrolling_up(...)                                      end,
          ['<a-q>'] = function(...) return actions.close(...) end,
        },
        n = {
          ['q'] = function(...) return actions.close(...) end,
        },
      },
    },
  }
end

local function _ts_opts(path, callback, any)
  return {
    cwd = path,
    search_dirs = { path },
    attach_mappings = function(prompt_bufnr, map)
      local actions = require('telescope.actions')
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = require('telescope.actions.state').get_selected_entry()
        local filename = selection.filename
        if filename == nil then
          filename = selection[1]
        end
        callback(filename, any)
      end)
      return true
    end,
  }
end

-- stylua: ignore
function M.neotree()
  local telescope = require('telescope.builtin')
  local fs = require('neo-tree.sources.filesystem')
  return {
    window = {
      mappings = {
        ['<c-e>'] = function() vim.api.nvim_exec('Neotree focus filesystem left', true) end,
        ['<c-b>'] = function() vim.api.nvim_exec('Neotree focus buffers left', true) end,
        ['<c-g>'] = function() vim.api.nvim_exec('Neotree focus git_status left', true) end,
        -- default
        ['<space>'] = {
          'toggle_node',
          nowait = false, -- disable `nowait` if you have existing combos starting with this char that you want to use
        },
        ['<2-LeftMouse>'] = 'open',
        ['<cr>'] = 'open',
        ['<esc>'] = 'revert_preview',
        ['P'] = { 'toggle_preview', config = { use_float = true } },
        ['l'] = 'focus_preview',
        ['S'] = 'open_split',
        ['v'] = 'open_vsplit',
        ['w'] = 'open_with_window_picker',
        ['C'] = 'close_node',
        ['z'] = 'close_all_nodes',
        --["Z"] = "expand_all_nodes",
        ['R'] = 'refresh',
        ['a'] = {
          'add',
          -- some commands may take optional config options, see `:h neo-tree-mappings` for details
          config = {
            show_path = 'none', -- "none", "relative", "absolute"
          },
        },
        ['A'] = 'add_directory', -- also accepts the config.show_path and config.insert_as options.
        ['d'] = 'delete',
        ['r'] = 'rename',
        ['y'] = 'copy_to_clipboard',
        ['x'] = 'cut_to_clipboard',
        ['p'] = 'paste_from_clipboard',
        ['c'] = 'copy', -- takes text input for destination, also accepts the config.show_path and config.insert_as options
        ['m'] = 'move', -- takes text input for destination, also accepts the config.show_path and config.insert_as options
        ['q'] = 'close_window',
        ['?'] = 'show_help',
        ['<'] = 'prev_source',
        ['>'] = 'next_source',
      },
    },
    filesystem = {
      window = {
        mappings = {
          ['O'] = 'system_open',
          ['f'] = 'telescope_find',
          ['F'] = 'telescope_find_root',
          ['g'] = 'telescope_grep',
          ['G'] = 'telescope_grep_root',
          ['n'] = 'neovide_open',
          ['e'] = 'embed_terminal_open',
          ['E'] = 'embed_terminal_open_root',
          ['<c-t>'] = 'terminal_open',
          ['<c-s-t>'] = 'terminal_open_root',
          -- default
          ['H'] = 'toggle_hidden',
          ['/'] = 'fuzzy_finder',
          ['D'] = 'fuzzy_finder_directory',
          --["/"] = "filter_as_you_type", -- this was the default until v1.28
          ['#'] = 'fuzzy_sorter', -- fuzzy sorting using the fzy algorithm
          -- ["D"] = "fuzzy_sorter_directory",
          ['s'] = 'filter_on_submit',
          ['<c-x>'] = 'clear_filter',
          ['<bs>'] = 'navigate_up',
          ['.'] = 'set_root',
          ['[g'] = 'prev_git_modified',
          [']g'] = 'next_git_modified',
          ['h'] = function(state)
            -- https://github.com/nvim-neo-tree/neo-tree.nvim/issues/531
            local node = state.tree:get_node()
            require('neo-tree.ui.renderer').focus_node(state, node:get_parent_id())
          end,
          ['l'] = function(state)
            local node = state.tree:get_node()
            if node:has_children() then
              require('neo-tree.ui.renderer').focus_node(state, node:get_child_ids()[1])
            end
          end,
        },
        -- define keymaps for filter popup window in fuzzy_finder_mode
        fuzzy_finder_mappings = {
          ['<down>'] = 'move_cursor_down',
          ['<c-n>'] = 'move_cursor_down',
          ['<up>'] = 'move_cursor_up',
          ['<c-p>'] = 'move_cursor_up',
        },
      },
      commands = {
        system_open = function(state)
          local path = state.tree:get_node():get_id()
          base.open(path)
        end,
        telescope_find = function(state)
          local path = state.tree:get_node():get_id()
          local is_directory = vim.fn.isdirectory(path) > 0
          if not is_directory then
            path = base.get_contain_directory(path)
          end
          telescope.find_files(_ts_opts(path, function(name, state)
            fs.navigate(state, state.path, name)
          end, state))
        end,
        telescope_find_root = function(state)
          local path = base.get_root()
          telescope.find_files(_ts_opts(path, function(name, state)
            fs.navigate(state, state.path, name)
          end, state))
        end,
        telescope_grep = function(state)
          local path = state.tree:get_node():get_id()
          local is_directory = vim.fn.isdirectory(path) > 0
          if not is_directory then
            path = base.get_contain_directory(path)
          end
          telescope.live_grep(_ts_opts(path, function(name, state)
            fs.navigate(state, state.path, name)
          end, state))
        end,
        telescope_grep_root = function(state)
          local path = base.get_root()
          telescope.live_grep(_ts_opts(path, function(name, state)
            fs.navigate(state, state.path, name)
          end, state))
        end,
      },
    },
  }
end

M.opts = {
  -- use gz mappings instead of s to prevent conflict with leap
  -- stylua: ignore
  ['mini.surround'] = {
    mappings = {
      add            = 'gza', -- Add surrounding in Normal and Visual modes
      delete         = 'gzd', -- Delete surrounding
      find           = 'gzf', -- Find surrounding (to the right)
      find_left      = 'gzF', -- Find surrounding (to the left)
      highlight      = 'gzh', -- Highlight surrounding
      replace        = 'gzr', -- Replace surrounding
      update_n_lines = 'gzn', -- Update `n_lines`
    },
  },
  -- stylua: ignore
  ['mini.align'] = {
    mappings = {
      start              = 'gma',
      start_with_preview = 'gmA',
    },
  },
  -- stylua: ignore
  ['mini.bracketed'] = {
    file       = { suffix = '',  options = {} },
    quickfix   = { suffix = '',  options = {} },
    window     = { suffix = '',  options = {} },
    buffer     = { suffix = 'b', options = {} },
    comment    = { suffix = 'c', options = {} },
    conflict   = { suffix = 'x', options = {} },
    diagnostic = { suffix = 'd', options = {} },
    indent     = { suffix = 'i', options = {} },
    jump       = { suffix = 'j', options = {} },
    location   = { suffix = 'l', options = {} },
    oldfile    = { suffix = 'o', options = {} },
    treesitter = { suffix = 'n', options = {} },
    undo       = { suffix = 'u', options = {} },
    yank       = { suffix = 'y', options = {} },
  }
,
}

-- stylua: ignore
function M.ts()
  local opts = {
    -- bulitin nvim-treesitter begin
    incremental_selection = {
      keymaps = {
        -- init_selection    = '<space>', -- 'Increment selection'
        -- node_incremental  = '<space>', -- 'Increment selection'
        -- scope_incremental = false, -- '<nop>'
        -- node_decremental  = '<bs>', -- 'Decrement selection'
        init_selection    = 'g<space>', -- set to `false` to disable one of the mappings
        node_incremental  = 'g<space>',
        scope_incremental = false, -- "grc"
        node_decremental  = '<bs>',
      },
    },
  }
  return opts
end

-- stylua: ignore start
local function _copy_content()           return base.copy_to_clipboard(base.get_content())                           end
local function _copy_path()              return base.copy_to_clipboard(base.to_native(base.get_path()))              end
local function _copy_relative_path()     return base.copy_to_clipboard(base.to_native(base.get_relative_path()))     end
local function _copy_name()              return base.copy_to_clipboard(base.name())                                  end
local function _copy_name_without_ext()  return base.copy_to_clipboard(base.get_name_without_ext())                  end
local function _copy_contain_directory() return base.copy_to_clipboard(base.to_native(base.get_contain_directory())) end
local function _reveal_cwd_in_file_explorer()  base.open(vim.fn.getcwd())                                            end
local function _reveal_file_in_file_explorer() base.open(base.get_contain_directory())                               end
local function _open_with_default_app()        base.open(base.get_current_buffer_name())                             end
local function _rename() vim.cmd('IncRename ' .. vim.fn.expand('<cword>'))     end
-- stylua: ignore end

-- lua\range-highlight\init.lua
local function _get_range_number(cmd)
  local parse_cmd = require('cmd-parser').parse_cmd
  -- delay is range-hightlight will be loaded.
  -- local mark_to_number = require('range-highlight.helper').mark_to_number
  -- local forward_search_to_number = require('range-highlight.helper').forward_search_to_number
  -- local backward_search_to_number = require('range-highlight.helper').backward_search_to_number

  local function mark_to_number(start_mark)
    return vim.api.nvim_buf_get_mark(0, string.sub(start_mark, 2, -1))[1]
  end

  local function search_to_number(config)
    return function(pattern)
      local pattern_text, search_options = string.sub(pattern, 2, -2), 'n'
      if not config.forward then
        search_options = 'bn'
      end
      local line_number = vim.api.nvim_call_function('searchpos', {
        pattern_text,
        search_options,
      })[1]
      return line_number
    end
  end

  local forward_search_to_number = search_to_number({ forward = true })
  local backward_search_to_number = search_to_number({ forward = false })

  local range_handlers = {
    number = tonumber,
    mark = mark_to_number,
    forward_search = forward_search_to_number,
    backward_search = backward_search_to_number,
  }

  local start_line, end_line = 0, 0
  local current_line = vim.api.nvim_win_get_cursor(0)[1]
  local line_count = vim.api.nvim_buf_line_count(0)
  local result = parse_cmd(cmd)

  if not result.start_range then
    return -1, -1
  end

  if result.start_range == '%' or result.end_range == '%' then
    return 0, line_count
  end

  if result.start_range then
    if result.start_range == '$' then
      start_line = line_count
    elseif result.start_range == '.' then
      start_line = current_line
    else
      start_line = range_handlers[result.start_range_type](result.start_range)
    end
  else
    start_line = current_line
  end

  if result.start_increment then
    start_line = start_line + result.start_increment_number
  end

  if result.end_range then
    if result.end_range == '$' then
      end_line = line_count
    elseif result.end_range == '.' then
      end_line = current_line
    else
      end_line = range_handlers[result.end_range_type](result.end_range)
    end
  else
    end_line = start_line
  end

  if result.end_increment then
    end_line = end_line + result.end_increment_number
  end

  start_line = start_line - 1
  return start_line, end_line
end

local function _copy_lines()
  local prompt = 'Copy Lines (Ranges)'
  local input_opts = { prompt = prompt, completion = 'lsp' }
  vim.ui.input(input_opts, function(input)
    if not input then
      return
    end
    local cmd_line = input
    if not cmd_line:match('^%d+') and not cmd_line:match('^%d,%d+') then
      return false
    end
    local start_line, end_line = _get_range_number(cmd_line)
    if start_line ~= -1 and end_line ~= -1 then
      local lines = vim.api.nvim_buf_get_lines(0, start_line, end_line, true)
      base.copy_to_clipboard(lines)
    end
  end)
end

local function _command_history()
  local conf = require('telescope.config').values
  local finders = require('telescope.finders')
  local actions = require('telescope.actions')
  local action_set = require('telescope.actions.set')
  local action_state = require('telescope.actions.state')
  local pickers = require('telescope.pickers')

  local history_string = vim.fn.execute('history cmd')
  local history_list = vim.split(history_string, '\n')

  local results = {}
  local opts = {}
  local filter_fn = opts.filter_fn

  for i = #history_list, 3, -1 do
    local item = history_list[i]
    local _, finish = string.find(item, '%d+ +')
    local cmd = string.sub(item, finish + 1)

    if filter_fn then
      if filter_fn(cmd) then
        table.insert(results, cmd)
      end
    else
      table.insert(results, cmd)
    end
  end

  pickers
    .new(opts, {
      prompt_title = 'Command History',
      finder = finders.new_table(results),
      sorter = conf.generic_sorter(opts),

      attach_mappings = function(_, map)
        actions.select_default:replace(actions.set_command_line)
        map({ 'i', 'n' }, '<c-e>', actions.edit_command_line)
        map({ 'i', 'n' }, '<c-m>', function(prompt_bufnr)
          local selection = action_state.get_selected_entry()
          if selection == nil then
            return
          end
          base.copy_to_clipboard(selection.value)
        end)
        return true
      end,
    })
    :find()
end

local function _copy_all_cmd_history()
  local history_string = vim.fn.execute('history cmd')
  local history_list = vim.split(history_string, '\n')
  local results = {}
  for i = #history_list, 3, -1 do
    local item = history_list[i]
    local _, finish = string.find(item, '%d+ +')
    local cmd = string.sub(item, finish + 1)
    table.insert(results, cmd)
  end
  base.copy_to_clipboard(results)
end

local function _search_history()
  local conf = require('telescope.config').values
  local finders = require('telescope.finders')
  local actions = require('telescope.actions')
  local action_set = require('telescope.actions.set')
  local action_state = require('telescope.actions.state')
  local pickers = require('telescope.pickers')

  local search_string = vim.fn.execute('history search')
  local search_list = vim.split(search_string, '\n')

  local results = {}
  for i = #search_list, 3, -1 do
    local item = search_list[i]
    local _, finish = string.find(item, '%d+ +')
    table.insert(results, string.sub(item, finish + 1))
  end

  pickers
    .new(opts, {
      prompt_title = 'Search History',
      finder = finders.new_table(results),
      sorter = conf.generic_sorter(opts),

      attach_mappings = function(_, map)
        actions.select_default:replace(actions.set_search_line)
        map({ 'i', 'n' }, '<C-e>', actions.edit_search_line)
        map({ 'i', 'n' }, '<c-m>', function(prompt_bufnr)
          local selection = action_state.get_selected_entry()
          if selection == nil then
            return
          end
          base.copy_to_clipboard(selection.value)
        end)
        return true
      end,
    })
    :find()
end

local function _copy_all_search_history()
  local search_string = vim.fn.execute('history search')
  local search_list = vim.split(search_string, '\n')
  local results = {}
  for i = #search_list, 3, -1 do
    local item = search_list[i]
    local _, finish = string.find(item, '%d+ +')
    table.insert(results, string.sub(item, finish + 1))
  end
  base.copy_to_clipboard(results)
end

-- lsp_document_symbols
-- lsp_dynamic_workspace_symbols
-- lsp_workspace_symbols
local function _telescope_symbols(e)
  local show_line = false
  local symbol_width = 0.3
  local fname_width = 0.6
  if e == 'lsp_document_symbols' then
    show_line = true
    fname_width = 0.0
    symbol_width = 0.6
  end
  require('telescope.builtin')[e]({
    fname_width = fname_width,
    symbol_width = symbol_width,
    show_line = show_line,
    layout_config = {
      height = 0.8,
      width = 0.8,
      prompt_position = 'top',
      preview_cutoff = 1,
      -- preview_width = 0,
      preview_height = 0.3,
    },
    layout_strategy = 'vertical',
    -- About symbols Kind
    -- Kind and the language server specification
    -- for SymbolKind. E.g. File, Constructor, Enum, etc...
    -- https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#textDocument_documentSymbol
    -- lazy\nvim-navic\doc\navic.txt
    -- lazy\vim-lsp-cxx-highlight\doc\vim-lsp-cxx-highlight.txt
    --[[
      /**
      * A symbol kind.
      */
      export namespace SymbolKind {
        export const File = 1;
        export const Module = 2;
        export const Namespace = 3;
        export const Package = 4;
        export const Class = 5;
        export const Method = 6;
        export const Property = 7;
        export const Field = 8;
        export const Constructor = 9;
        export const Enum = 10;
        export const Interface = 11;
        export const Function = 12;
        export const Variable = 13;
        export const Constant = 14;
        export const String = 15;
        export const Number = 16;
        export const Boolean = 17;
        export const Array = 18;
        export const Object = 19;
        export const Key = 20;
        export const Null = 21;
        export const EnumMember = 22;
        export const Struct = 23;
        export const Event = 24;
        export const Operator = 25;
        export const TypeParameter = 26;
      }
    ]]
    symbols = {
      'File',
      'Module',
      'Namespace',
      'Package',
      'Class',
      'Method',
      'Property',
      'Field',
      'Constructor',
      'Enum',
      'Interface',
      'Function',
      'Variable',
      'Constant',
      'String',
      'Number',
      'Boolean',
      'Array',
      'Object',
      'Key',
      'Null',
      'EnumMember',
      'Struct',
      'Event',
      'Operator',
      'TypeParameter',
    },
  })
end

local function _neotree()
  local path = base.get_path()
  local root = base.get_root()
  if base.is_noname(path) then
    path = root
  end
  -- lazy\neovim\runtime\lua\vim\secure.lua
  local fullpath = vim.loop.fs_realpath(vim.fs.normalize(path))
  if not fullpath then
    return base.warn(string.format('Invalid path: %s', path))
  end
  if base.is_windows() then
    path = base.safe_nt(path)
  end
  vim.api.nvim_set_current_dir(root)
  vim.cmd('Neotree ' .. path)
  -- vim.cmd('Neotree toggle ' .. path)
end

local function _diagnostic_goto(next, severity)
  local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    go({ severity = severity })
  end
end
local function _go_trouble(next)
  return function()
    if require('trouble').is_open() then
      local x = next == true and require('trouble').next or require('trouble').previous
      x({ skip_groups = true, jump = true })
    else
      local vimc = next == true and vim.cmd.cnext or vim.cmd.cprev
      vimc()
    end
  end
end
local function _ref_map(key, dir)
  M.map('n', key, function()
    require('illuminate')['goto_' .. dir .. '_reference'](false)
  end, { desc = dir:sub(1, 1):upper() .. dir:sub(2) .. ' Reference' })
end

-- vim.api.nvim_get_mode()
-- lazy\neovim\src\nvim\state.c
-- /// Returns the current mode as a string in "buf[MODE_MAX_LENGTH]", NUL
-- /// terminated.
-- /// The first character represents the major mode, the following ones the minor
-- /// ones.
-- Normal  n
-- Insert  i
-- Cmdline c
-- Visual  v
-- V-Line  V
local function _any_comment(wise)
  local mode = vim.api.nvim_get_mode().mode
  if mode:find('n') then
    wise.current()
  elseif mode:find('v') or mode:find('V') then
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<esc>', true, false, true), 'nx', false)
    wise(vim.fn.visualmode())
  end
end
local function _comment_line()
  _any_comment(require('Comment.api').toggle.linewise)
end
local function _comment_block()
  _any_comment(require('Comment.api').toggle.blockwise)
end
local function _close_view()
  if #vim.api.nvim_list_wins() == 1 then
    require('close_buffers').delete({ type = 'this' })
  else
    vim.api.nvim_win_close(0, true)
  end
end
local function _toggle_wrap()
  base.toggle('wrap', false, { 'Wrap Hard', 'Not Wrap' })
end
local function _toggle_case_sensitive()
  base.toggle('ignorecase', false, { 'Ignore Case', 'Case Sensitive' })
end
local function _toggle_showlist()
  base.toggle('list', false, { 'Show List', 'Hide List' })
end
local function _toggle_fullscreen()
  vim.g.neovide_fullscreen = vim.g.neovide_fullscreen == false
end
local function _toggle_focus_mode()
  vim.opt.laststatus = vim.opt.laststatus._value == 0 and 3 or 0
end
local function _toggle_diagnostics()
  if vim.diagnostic.is_disabled() then
    vim.diagnostic.enable()
    base.info('Enabled diagnostics', { title = 'Diagnostics' })
  else
    vim.diagnostic.disable()
    base.warn('Disabled diagnostics', { title = 'Diagnostics' })
  end
end
local function _remove_exclusive_orm()
  vim.cmd([[:%s/\r//g]])
  vim.cmd([[set ff=unix]])
end
local function _insert_date()
  -- vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('i', true, true, true), 'n', true)
  -- vim.cmd([[i]])
  vim.cmd([[startinsert]])
  vim.api.nvim_feedkeys(os.date('%Y-%m-%d', os.time()) .. ' ', 'i', true)
end
local function _insert_time()
  vim.cmd([[startinsert]])
  vim.api.nvim_feedkeys(os.date('%H:%M:%S', os.time()) .. ' ', 'i', true)
end
local function _insert_tz8()
  vim.cmd([[startinsert]])
  vim.api.nvim_feedkeys(os.date('%Y-%m-%d %H:%M:%S +0800', os.time()) .. ' ', 'i', true)
end
local function _sublime_merge()
  require('plenary.job'):new({ command = 'sublime_merge', args = { '-n', vim.fn.getcwd() } }):sync()
end
local function _sublime_text()
  require('plenary.job'):new({ command = 'sublime_text', args = { vim.fn.getcwd() } }):sync()
end
local function _telescope_projects()
  require('project_nvim')
  local timer = vim.loop.new_timer()
  local function picker()
    timer:stop()
    require('telescope').extensions.projects.projects()
  end
  timer:start(8, 0, vim.schedule_wrap(picker))
end
local function _toggle_wholeword()
  base.g_toggle('wholeword', { 'Match Whole Word', 'Dont Care Whole Word', 'Search Option' })
end
local function _search()
  local function _has_wholeword()
    return vim.g.wholeword and vim.g.wholeword == true
  end
  local mww = _has_wholeword() and 'match whole word + ' or 'dont care whole word + '
  local mc = vim.opt.ignorecase:get() == false and 'match case' or 'ignore case'
  local prompt = 'Search (' .. mww .. mc .. ')'
  local input_opts = { prompt = prompt, completion = 'lsp' }
  vim.ui.input(input_opts, function(input)
    if not input then
      return
    end
    if vim.g.wholeword == true then
      vim.cmd('/\\<' .. input .. '\\>')
    else
      vim.cmd('/' .. input)
    end
  end)
end

-- lazy\agrolens.nvim\lua\telescope\_extensions\agrolenslib.lua
local function _matchstr(...)
  local ok, ret = pcall(vim.fn.matchstr, ...)
  return ok and ret or ''
end

-- lazy\aerial.nvim\lua\aerial\backends\treesitter\extensions.lua
local function _get_line_len(bufnr, lnum)
  return vim.api.nvim_strwidth(vim.api.nvim_buf_get_lines(bufnr, lnum - 1, lnum, true)[1])
end

-- lazy\agrolens.nvim\lua\telescope\_extensions\agrolenslib.lua
local function _get_word_at_cursor()
  local column = vim.api.nvim_win_get_cursor(0)[2]
  local line = vim.api.nvim_get_current_line()
  local left = _matchstr(line:sub(1, column + 1), [[\k*$]])
  local right = _matchstr(line:sub(column + 1), [[^\k*]]):sub(2)
  return left .. right
end

-- lazy\Bekaboo-nvim\ftplugin\markdown\capitalized-title.lua
---Returns the character after the cursor
---@return string
local function _get_char_after()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local current_line = vim.api.nvim_buf_get_lines(0, cursor[1] - 1, cursor[1], true)[1]
  return current_line:sub(cursor[2], cursor[2])
end

-- lazy\LuaSnip\lua\luasnip\util\util.lua
local function _get_string_before()
  local cursor = vim.api.nvim_win_get_cursor(0)
  -- cur-rows are 1-indexed, api-rows 0.
  local line = vim.api.nvim_buf_get_lines(0, cursor[1] - 1, cursor[1], true)[1]
  return string.sub(line, 1, cursor[2])
end

-- lazy\Bekaboo-nvim\ftplugin\markdown\capitalized-title.lua
local function _get_char_at_cursor()
  local column = vim.api.nvim_win_get_cursor(0)[2]
  local line = vim.api.nvim_get_current_line()
  return line:sub(column, column + 1)
end

-- lazy\messages.nvim\tests\plenary\messages_spec.lua
local function _get_buf_text(bufnr)
  return vim.fn.join(vim.api.nvim_buf_get_lines(bufnr or 0, 0, -1, true), '\n')
end

-- lazy\mini.nvim\lua\mini\align.lua
local function _is_visual_mode()
  return vim.tbl_contains({ 'v', 'V', '\22' }, vim.fn.mode(1))
end

local function _delete_line_contain(method)
  local prompt = 'Delete Lines (Regular Expression)'
  local input_opts = { prompt = prompt, completion = 'lsp' }
  local keys = nil
  if method == 'input' then
    return vim.ui.input(input_opts, function(input)
      if not input then
        return
      end
      -- \.
      -- input = input:gsub('\\.', '\\\\.')
      vim.cmd('g/' .. input .. '/norm dd')
    end)
  elseif method == 'word' then
    keys = _get_word_at_cursor()
  elseif method == 'char' then
    keys = _get_char_at_cursor()
  end
  if keys then
    -- The most efficient way is to combine :global and :norm
    -- https://stackoverflow.com/a/73580651
    vim.cmd('g/' .. keys .. '/norm dd')
  end
end

local function _remove_all(method)
  local prompt = 'Remove All (Regular Expression)'
  local input_opts = { prompt = prompt, completion = 'lsp' }
  local keys = nil
  if method == 'input' then
    return vim.ui.input(input_opts, function(input)
      if not input then
        return
      end
      vim.cmd('%s/' .. input .. '//g')
    end)
  elseif method == 'word' then
    keys = _get_word_at_cursor()
  elseif method == 'char' then
    keys = _get_char_at_cursor()
  elseif method == 'space' then
    keys = ' '
  end
  if keys then
    -- The most efficient way is to combine :global and :norm
    -- https://stackoverflow.com/a/73580651
    vim.cmd('%s/' .. keys .. '//g')
  end
end

-- lazy\duplicate.nvim\lua\duplicate\init.lua
local function _duplicate_line()
  -- useful functions:
  -- local key = vim.api.nvim_replace_termcodes(shortcut, true, false, true)
  -- vim.api.nvim_feedkeys(key, "normal", false)

  -- Bug: doesn't work?
  -- vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<esc>', true, false, true), 'nx', false)
  -- vim.api.nvim_feedkeys('ydd', 'n', false)

  local line_nr, _ = unpack(vim.api.nvim_win_get_cursor(0))
  local line_count = 1
  local lines = vim.api.nvim_buf_get_lines(0, line_nr - 1, line_nr + line_count - 1, false)
  local last_line = line_nr + line_count - 1
  vim.api.nvim_buf_set_lines(0, last_line, last_line, false, lines)
  -- Set Cursor to duplicated line
  local cursor_line, cursor_col = unpack(vim.api.nvim_win_get_cursor(0))
  vim.api.nvim_win_set_cursor(0, { cursor_line + line_count, cursor_col })
end

local function _ddldbl(method)
  if method == 'duplines' then
    vim.cmd([[DDL]])
  elseif method == 'emptylines' then
    vim.cmd([[DBL]])
  end
end

local function _format()
  if type(vim.bo.filetype) == 'string' and vim.bo.filetype:match('lua') then
    vim.cmd('FormatWriteLock')
  else
    vim.lsp.buf.format({ async = false })
  end
end
local function _format_document()
  _format()
  -- vim.cmd([[confirm! set ff=unix]])
  -- vim.cmd([[set modifiable]])
  -- vim.cmd([[set ff=unix]])
  -- vim.cmd([[wa]])
end
local function _toggle_autoformat()
  base.g_toggle('autoformat', { 'Auto format before saved', 'Dont auto format', 'Auto Format' })
end

-- which-key
function M.wk(wk)
  -- stylua: ignore
  local wk_ve = {
      name = '+Edit Config',
      i = { function() vim.cmd('e ' .. vim.fn.stdpath('config') .. '/init.lua')                end, 'init.lua (bootstrap)' },
      b = { function() vim.cmd('e ' .. vim.fn.stdpath('config') .. '/lua/base.lua')            end, 'base.lua' },
      k = { function() vim.cmd('e ' .. vim.fn.stdpath('config') .. '/lua/module/bindings.lua') end, 'bindings.lua' },
      l = { function() vim.cmd('e ' .. vim.fn.stdpath('config') .. '/lua/module/lsp.lua')      end, 'lsp.lua' },
      o = { function() vim.cmd('e ' .. vim.fn.stdpath('config') .. '/lua/module/options.lua')  end, 'options.lua' },
      p = { function() vim.cmd('e ' .. vim.fn.stdpath('config') .. '/lua/module/plugins.lua')  end, 'plugins.lua' },
      s = { function() vim.cmd('e ' .. vim.fn.stdpath('config') .. '/lua/module/settings.lua') end, 'settings.lua' },
    }
  -- stylua: ignore
  local nvx = {
    ['<tab>'] = { name = '+Tabs' },
    q = {
      name = '+Quit',
      q = { '<cmd>qa<cr>',    'Quit All' },
      w = { '<cmd>wqall<cr>', 'Quit And Save Everything' },
      f = { '<cmd>q!<cr>',    'Quit Force' },
      F = { '<cmd>qa!<cr>',   'Quit All Force' },
      -- s = { '<cmd>w<cr>', 'Save' },
      s = {
        name = '+Session',
        a = { '<cmd>lua require("persistence").load()<cr>',                'Restore AutoSaved (persistence.nvim)' },
        b = { function() require('persistence').load() end,                'Restore (persistence.nvim)' },
        c = { function() require('persistence').load({ last = true }) end, 'Restore Last (persistence.nvim)' },
        d = { function() require('persistence').stop() end,                "Don't Save Current (persistence.nvim)" },
      },
    },
    c = {
      name = '+C++',
      -- c -- Comment
      -- f -- LSP Format Doucment/Range
      a = { '<cmd>ClangAST<cr>',                     'Clang AST' },
      t = { '<cmd>ClangdTypeHierarchy<cr>',          'Clang Type Hierarchy' },
      h = { '<cmd>ClangdSwitchSourceHeader<cr>',     'Switch C/C++ Header/Source' },
      m = { '<cmd>ClangdMemoryUsage<cr>',            'Clangd Memory Usage' },
      g = { '<cmd>Godbolt!<cr>',                     'Godbolt ASM Code' },
    },
    w = {
      name = '+Windows',
      b = {
        name = '+Blank New File In A Split',
        h = { '<cmd>new<cr>',  'New Horizontal' },
        v = { '<cmd>vnew<cr>', 'New Vertically' },
      },
      h = { '<c-w>h', 'Jump Left' },
      j = { '<c-w>j', 'Jump Down' },
      k = { '<c-w>k', 'Jump Up' },
      l = { '<c-w>l', 'Jump Right' },
      e = { '<cmd>vsplit<cr><esc>',       'Split Left' },
      d = { '<cmd>split<cr><c-w>j<esc>',  'Split Down' },
      u = { '<cmd>split<cr><esc>',        'Split Up' },
      r = { '<cmd>vsplit<cr><c-w>l<esc>', 'Split Right' },
      o = { '<cmd>only<cr>',  'Only' },
      c = { '<cmd>close<cr>', 'Close' },
      s = {
        name = '+Swapping Buffers Between Windows',
        h = { function() require('smart-splits').swap_buf_left()  end, 'Left' },
        l = { function() require('smart-splits').swap_buf_right() end, 'Right' },
        j = { function() require('smart-splits').swap_buf_down()  end, 'Down' },
        k = { function() require('smart-splits').swap_buf_up()    end, 'Up' },
      },
    },
    b = {
      name = '+Buffer',
      c = { '<cmd>Bdelete<cr>',                                 'Buffer Close' },
      e = { ':ene <bar> startinsert <cr>',                      'New Buffer' },
      n = { ':ene <bar> startinsert <cr>',                      'New Buffer' },
      f = { '<cmd>FlyBuf<cr>',                                  'Fly Buffer' },
      p = { '<Cmd>BufferLineTogglePin<cr>',                     'Toggle pin' },
      u = { '<Cmd>BufferLineGroupClose ungrouped<cr>',          'Delete non-pinned buffers, Only pinned' },
      o = { '<cmd>BWipeout other<cr>',                          'Only Current Buffer' },
      a = { '<cmd>Telescope buffers show_all_buffers=true<cr>', 'Switch Buffer' },
      d = { function() require('mini.bufremove').delete(0, false)       end, 'Delete Buffer' },
      D = { function() require('mini.bufremove').delete(0, true)        end, 'Delete Buffer (Force)' },
    },
    v = {
      name = '+Vim',
      e = wk_ve,
      a = { '<cmd>Alpha<cr>',            'Toggle Alpha Dashboard' },
      f = { '<cmd>ToggleFullScreen<cr>', 'Toggle FullScreen' },
      i = { '<cmd>Lazy<cr>',             'Lazy Dashboard' },
      p = { '<cmd>Lazy profile<cr>',     'Lazy Profile' },
      u = { '<cmd>Lazy update<cr>',      'Lazy Update' },
      c = { '<cmd>Lazy clean<cr>',       'Lazy Clean' },
      s = { vim.show_pos,                'Inspect Pos' },
    },
    h = {
      name = '+History/Notifications',
      l = { function() require('noice').cmd('last')    end, 'Noice Last Message', },
      h = { function() require('noice').cmd('history') end, 'Noice History', },
      a = { function() require('noice').cmd('all')     end, 'Noice All', },
      d = { _purge_notify,                        'Delete all Notifications' },
      n = { _notify_history,                      'Notification History' },
      m = { function() vim.cmd('messages') end,   'Message History' },   
      s = { _search_history,                      'Search History' },
      S = { _copy_all_search_history,             'Copy All Search History' },
      c = { _command_history,                     'Command History' },
      C = { _copy_all_cmd_history,                'Copy All Command History' },
    },
    l = {
      name = '+LSP',
      i = { '<cmd>LspInfo<cr>',        'Info' },
      l = { vim.diagnostic.open_float, 'Line Diagnostics' },
      f = { '<cmd>FormatDocument<cr>', 'Format Document' },
      s = { function() _telescope_symbols('lsp_document_symbols')          end, 'Document Symbols', },
      d = { function() _telescope_symbols('lsp_dynamic_workspace_symbols') end, 'Dynamic Workspace Symbols', },
      -- w = { function() _telescope_symbols('lsp_workspace_symbols')         end, 'Workspace Symbols', },
      -- l = { function() _telescope_symbols('live_workspace_symbols')        end, 'Workspace Symbols', },
    },
    x = {
      name = '+Diagnostics/Quickfix',
      d = { '<cmd>TroubleToggle document_diagnostics<cr>',  'Trouble Document Diagnostics (Trouble)' },
      w = { '<cmd>TroubleToggle workspace_diagnostics<cr>', 'Workspace Diagnostics (Trouble)' },
      l = { '<cmd>TroubleToggle loclist<cr>',               'Location List (Trouble)' },
      q = { '<cmd>TroubleToggle quickfix<cr>',              'Quickfix List (Trouble)' },
      t = { '<cmd>TodoTrouble<cr>',                         'Todo (Trouble)' },
      k = { '<cmd>TodoTrouble keywords=TODO,                FIX,FIXME<cr>', 'Todo/Fix/Fixme (Trouble)' },
      L = { '<cmd>lopen<cr>',                               'Location List' },
      Q = { '<cmd>copen<cr>',                               'Quickfix List' },
      D = { '<cmd>Telescope diagnostics bufnr=0<cr>',       'Document Diagnostics' },
      x = { '<cmd>TroubleToggle<cr>',                       'Trouble Toggle' },
      r = { '<cmd>TroubleToggle lsp_references<cr>',        'Trouble LSP References' },
    },
    e = {
     name = '+Edit',
      a = {
        name = 'Delete All',
        d = { function() _remove_all('input') end,  'Delete all certain text' },
        w = { function() _remove_all('word')  end,  'Delete all current word' },
        c = { function() _remove_all('char')  end,  'Delete all current char' },
        s = { function() _remove_all('space')  end, 'Delete all space' },
      },
      l = {
        name = 'Lines',
        s = { '<cmd>InsertSequenceNumber<cr>', 'Insert Sequence Number' },
        d = { function() _duplicate_line() end, 'Duplicate lines' },
        i = { function() _delete_line_contain('input') end, 'Delete lines that contain certain text' },
        w = { function() _delete_line_contain('word')  end, 'Delete lines that contain current word' },
        c = { function() _delete_line_contain('char')  end, 'Delete lines that contain current char' },
        u = { function() _ddldbl('duplines') end, 'Delete duplines without sort' },
        e = { function() _ddldbl('emptylines')  end, 'Delete all empty lines' },
      },
      t = {
        name = 'Toggle',
        a = { '<cmd>ToggleAutoFormat<cr>',    'Auto Format Toggle' },
        w = { '<cmd>ToggleWrap<cr>',          'Toggle Wrap' },
        c = { '<cmd>ToggleCaseSensitive<cr>', 'Toggle Case Sensitive' },
        t = { '<cmd>Twilight<cr>',            'Twilight Dims Inactive' },
        f = { '<cmd>ToggleFocusMode<cr>',     'Toggle Focus Mode' },
      },
      c = {
        name = '+Copy Information',
        l = { _copy_lines,             'Copy Lines' },
        c = { _copy_content,           'Copy Content' },
        n = { _copy_name,              'Copy File Name' },
        e = { _copy_name_without_ext,  'Copy File Name Without Ext' },
        d = { _copy_contain_directory, 'Copy Contain Directory' },
        p = { _copy_path,              'Copy Path' },
        r = { _copy_relative_path,     'Copy Relative Path' },
      },
      e = {
        name = '+Ending',
        l = { '<cmd>RemoveExclusiveORM<cr>', 'ORM Ending' },
        u = { '<cmd>set ff=unix<cr>',        'Unix Ending' },
        w = { '<cmd>set ff=dos<cr>',         'Windows Ending' },
        m = { '<cmd>set ff=mac<cr>',         'Mac Ending' },
      },
    },
    f = {
      name = '+Fuzzy/File/Explorer',
      s = { '<cmd>confirm wa<cr>',                                              'Save All' },
      e = { _neotree,                                                           'Neotree Explorer' },
      d = { '<cmd>NeoTreeFocusToggle<cr>',                                      'Toggle Neotree Explorer' },
      f = { '<cmd>Telescope find_files theme=get_dropdown previewer=false<cr>', 'Find files' },
      l = { '<cmd>Telescope live_grep_args<cr>',                                'Find Text Args' },
      p = { '<cmd>Projects<cr>',                                                'Projects' },
      w = { '<cmd>Telescope projections<cr>',                                   'Workspaces' },
      o = { '<cmd>Telescope oldfiles<cr>',                                      'Frecency Files' },
      u = { '<cmd>Telescope undo bufnr=0<cr>',                                  'Undo Tree' },
      r = { '<cmd>Telescope repo list<cr>',                                     'Repo list' },
      a = { _open_with_default_app,                                             'Open With Default APP' },
      x = { _reveal_file_in_file_explorer,                                      'Reveal In File Explorer' },
    },
    r = {
      name = '+Register',
      r = { '<cmd>Telescope registers<cr>',                                'Registers' },
    }
  }
  wk.register(nvx, { mode = { 'n', 'v', 'x' }, prefix = '<leader>' })
  -- stylua: ignore
  local nv = {
    mode = { 'n', 'v' },
    ['g']  = { name = '+Goto' },
    ['gC'] = { name = '+Text Case' },
    ['gt'] = { name = '+TreeSitter' },
    ['gz'] = { name = '+Surround' },
    ['gm'] = { name = '+Mini Family' },
    [']']  = { name = '+Next' },
    ['[']  = { name = '+Prev' },
  }
  wk.register(nv)
  local n = {
    mode = { 'n' },
    ['q:'] = { name = '+Open your history in a new buffer' },
  }
  -- Bug: doesn't work `q:`
  wk.register(n)
  -- wk.register({
  --   ['<c-space>'] = { function() require('cmp').mapping.complete() end, 'Trigger completion'},
  --   ['<cr>'] = { function() require('cmp').mapping.confirm({ select = true }) end, 'Confirm completion' },
  -- }, { mode = 'i' })
  -- wk.register({
  --   ['<c-space>'] = { 'compe#complete()', 'Trigger completion', expr = true },
  --   ['<cr>'] = { "compe#confirm('<cr>')", 'Confirm completion', expr = true },
  -- }, { mode = 'i' })
end

-- stylua: ignore
local function map_core()
  M.semicolon_to_colon()

  -- Better up/down
  M.map('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true })
  M.map('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true })

  -- Better move cursor
  M.map('n', '<c-j>', '15gj', 'Move Down 15 Lines')
  M.map('n', '<c-k>', '15gk', 'Move Up 15 Lines')
  M.map('v', '<c-j>', '15gj', 'Move Down 15 Lines')
  M.map('v', '<c-k>', '15gk', 'Move Up 15 Lines')

  -- Better indenting
  M.map('v', '<', '<gv', 'deIndent Continuously')
  M.map('v', '>', '>gv', 'Indent Continuously')

  -- Add undo break-points
  M.map('i', '<cr>', '<cr><c-g>u')
  M.map('i', ' ', ' <c-g>u')
  M.map('i', ':', ':<c-g>u')
  M.map('i', ',', ',<c-g>u')
  M.map('i', '.', '.<c-g>u')
  M.map('i', ';', ';<c-g>u')
  M.map('i', '"', '"<c-g>u')
  M.map('i', '(', '(<c-g>u')
  M.map('i', '{', '{<c-g>u')
  M.map('i', '/',  '/<c-g>u')
end

local function map_file()
  -- Alternative way to save and exit in Normal mode.
  -- NOTE: Adding `redraw` helps with `cmdheight=0` if buffer is not modified
  M.map('n', '<c-s>', '<cmd>silent! update | redraw<cr>', { desc = 'Save' })
  M.map({ 'i', 'x' }, '<c-s>', '<esc><cmd>silent! update | redraw<cr>', { desc = 'Save and go to Normal mode' })
end

-- stylua: ignore
local function map_edit()
  M.map('n', 'S',     'diw"0P', 'Replace')
  M.map('n', '<a-c>', '<cmd>ToggleCaseSensitive<cr>')
  M.map('n', '<a-w>', '<cmd>ToggleWholeWord<cr>')
  M.map('n', '<a-e>', '<cmd>ToggleNeoColumn<cr>')

  -- Comment
  M.map('n', '<c-/>', '<cmd>CommentLine<cr>')
  M.map('n', '<leader>cc', '<cmd>CommentLine<cr>',  'Comment Line (Comment.nvim)')
  M.map('x', '<leader>cc', '<cmd>CommentLine<cr>',  'Comment Line (Comment.nvim)')
  M.map('n', '<leader>cb', '<cmd>CommentBlock<cr>', 'Comment Block (Comment.nvim)')
  M.map('x', '<leader>cb', '<cmd>CommentBlock<cr>', 'Comment Block (Comment.nvim)')

  -- Text Case
  M.map('n', '<leader>el', '<cmd>TextCaseLower<cr>', 'Text Case Lower')
  M.map('x', '<leader>el', '<cmd>TextCaseLower<cr>', 'Text Case Lower')
  M.map('n', '<leader>eu', '<cmd>TextCaseUpper<cr>', 'Text Case Upper')
  M.map('x', '<leader>eu', '<cmd>TextCaseUpper<cr>', 'Text Case Upper')

  -- Selection/ Move Lines
  M.map('n', '<a-j>', '<cmd>MoveLine(1)<cr>',   'Line: Move Up (move.nvim)')
  M.map('n', '<a-k>', '<cmd>MoveLine(-1)<cr>',  'Line: Move Down (move.nvim)')
  M.map('n', '<a-h>', '<cmd>MoveHChar(-1)<cr>', 'Line: Move Left (move.nvim)')
  M.map('n', '<a-l>', '<cmd>MoveHChar(1)<cr>',  'Line: Move Right (move.nvim)')
  M.map('v', '<a-j>', ':MoveBlock(1)<cr>',      'Block: Move Up (move.nvim)')
  M.map('v', '<a-k>', ':MoveBlock(-1)<cr>',     'Block: Move Down (move.nvim)')
  M.map('v', '<a-h>', ':MoveHBlock(-1)<cr>',    'Block: Move Left (move.nvim)')
  M.map('v', '<a-l>', ':MoveHBlock(1)<cr>',     'Block: Move Right (move.nvim)')

  -- [ ] Move
  M.map('n', ']d', _diagnostic_goto(true),           'Next Diagnostic')
  M.map('n', '[d', _diagnostic_goto(false),          'Prev Diagnostic')
  M.map('n', ']e', _diagnostic_goto(true, 'ERROR'),  'Next Error')
  M.map('n', '[e', _diagnostic_goto(false, 'ERROR'), 'Prev Error')
  M.map('n', ']w', _diagnostic_goto(true, 'WARN'),   'Next Warning')
  M.map('n', '[w', _diagnostic_goto(false, 'WARN'),  'Prev Warning')
  M.map('n', ']b', '<cmd>BufferLineCycleNext<cr>',   'Next buffer')
  M.map('n', '[b', '<cmd>BufferLineCyclePrev<cr>',   'Prev buffer')
  M.map('n', ']q', _go_trouble(true),                'Next trouble/quickfix item')
  M.map('n', '[q', _go_trouble(false),               'Prev trouble/quickfix item')
  _ref_map(']r', 'next') -- Next Reference
  _ref_map('[r', 'prev') -- Prev Reference
  M.map('n', ']t', function() require('todo-comments').jump_next() end, 'Next todo comment')
  M.map('n', '[t', function() require('todo-comments').jump_prev() end, 'Prev todo comment')

  -- Reselect latest changed, put, or yanked text
  M.map('n', 'gV', '"`[" . strpart(getregtype(), 0, 1) . "`]"', { expr = true, desc = 'Visually select changed text' })

  -- Delete without copy
  -- https://stackoverflow.com/questions/11993851/how-to-delete-not-cut-in-vim
  -- Use the "black hole register", "_ to really delete something: "_d.
  -- Use "_dP to paste something and keep it available for further pasting.
  -- d => "delete"
  -- leader d => "cut"
  vim.cmd([[
    " nnoremap x "_x
    " nnoremap d "_d
    " nnoremap D "_D
    " vnoremap d "_d
    vnoremap p "_dP
    " nnoremap <leader>d ""d
    " nnoremap <leader>D ""D
    " vnoremap <leader>d ""d
  ]])

  -- VSCode Keymap
  -- Insert Mode Improved
  -- ctrl+v paste in insert-mode, Do not need to leave mode. Keep Editing.
  -- ctrl+z undo
  -- ctrl+y redo
  -- ctrl+a select all
  -- ctrl+v paste
  -- ctrl+s save
  vim.cmd([[
    inoremap <c-z> <c-o>u
    inoremap <c-y> <c-o><c-r>
    inoremap <c-a> <c-o>gg<c-o>gH<c-o>G
    imap <c-v> "+gP
    exe 'inoremap <script> <c-v> <c-g>u' . paste#paste_cmd['i']
    " inoremap <c-s> <esc>:update<cr>gi "Noise, Fixed by map_file()
  ]])

  -- Change word with <c-c>
  M.map('n', '<c-c>', '<cmd>normal! ciw<cr>a', 'Change Word')
end

-- stylua: ignore
local function map_search()
  -- Clear search with <esc>
  M.map({ 'i', 'n' }, '<esc>', '<cmd>noh<cr><esc>', 'Escape And Clear hlsearch')

  -- Search word under cursor
  M.map({ 'n', 'x' }, 'gw', '*N', 'Search word under cursor')
end

-- stylua: ignore
local function map_view()
  -- Comamnd Palette
  M.map('n', '<c-s-p>', '<cmd>Telescope commands<cr>', 'Command Palette... (telescope.nvim)')
  -- M.map('n', [[\]],     '<cmd>Telescope commands<cr>', 'Command Palette... (telescope.nvim)')  

  -- Scroll
  M.map({ 'i', 'n', 's' }, '<c-f>', function() if not require('noice.lsp').scroll(4) then return '<c-f>' end end, { expr = true, desc = 'Scroll forward' })
  M.map({ 'i', 'n', 's' }, '<c-b>', function() if not require('noice.lsp').scroll(-4) then return '<c-b>' end end, { expr = true, desc = 'Scroll backward' })

  -- Move to window using the <ctrl> hjkl keys
  M.map('n', '<c-h>', '<c-w>h', 'Jump Left')
  -- M.map('n', '<c-j>', '<c-w>j', 'Jump Down')
  -- M.map('n', '<c-k>', '<c-w>k', 'Jump Up')
  M.map('n', '<c-l>', '<c-w>l', 'Jump Right')

  -- Move to window using the movement keys
  -- M.map('n', '<left>', '<c-w>h', 'Jump Left')
  -- M.map('n', '<down>', '<c-w>j', 'Jump Down')
  -- M.map('n', '<up>', '<c-w>k', 'Jump Up')
  -- M.map('n', '<right>', '<c-w>l', 'Jump Right')
  M.map('n', '<left>',  function() require('smart-splits').move_cursor_left()  end, 'Jump Left')
  M.map('n', '<down>',  function() require('smart-splits').move_cursor_down()  end, 'Jump Down')
  M.map('n', '<up>',    function() require('smart-splits').move_cursor_up()    end, 'Jump Up')
  M.map('n', '<right>', function() require('smart-splits').move_cursor_right() end, 'Jump Right')

  -- Automatically expand width of the current window.
  M.map('n', '<c-w>z', M.cmd('WindowsMaximize'))
  M.map('n', '<c-w>_', M.cmd('WindowsMaximizeVertically'))
  M.map('n', '<c-w>|', M.cmd('WindowsMaximizeHorizontally'))
  M.map('n', '<c-w>=', M.cmd('WindowsEqualize'))

  -- Resize window using <ctrl> arrow keys
  -- M.map('n', '<c-up>', '<cmd>resize +2<cr>', 'Increase window height')
  -- M.map('n', '<c-down>', '<cmd>resize -2<cr>', 'Decrease window height')
  -- M.map('n', '<c-left>', '<cmd>vertical resize -2<cr>', 'Decrease window width')
  -- M.map('n', '<c-right>', '<cmd>vertical resize +2<cr>', 'Increase window width')
  M.map('n', '<c-left>',  function() require('smart-splits').resize_left()  end, 'Increase window width')
  M.map('n', '<c-right>', function() require('smart-splits').resize_right() end, 'Decrease window width')
  M.map('n', '<c-down>',  function() require('smart-splits').resize_down()  end, 'Increase window height')
  M.map('n', '<c-up>',    function() require('smart-splits').resize_up()    end, 'Decrease window height')

  -- Window Move
  M.map('n', '<s-left>',  M.cmd('WinShift left'),  'Move Window To Left ')
  M.map('n', '<s-right>', M.cmd('WinShift right'), 'Move Window To Right')
  M.map('n', '<s-down>',  M.cmd('WinShift down'),  'Move Window To Down')
  M.map('n', '<s-up>',    M.cmd('WinShift up'),    'Move Window To Up')

  -- Wrap
  M.map('n', '<a-q>', '<cmd>ToggleWrap<cr>', 'Toggle Wrap')  
end

-- stylua: ignore
local function map_tabs()
  M.map('n', '<leader><tab>l',     '<cmd>tablast<cr>',     'Last Tab')
  M.map('n', '<leader><tab>f',     '<cmd>tabfirst<cr>',    'First Tab')
  M.map('n', '<leader><tab><tab>', '<cmd>tabnew<cr>',      'New Tab')
  M.map('n', '<leader><tab>]',     '<cmd>tabnext<cr>',     'Next Tab')
  M.map('n', '<leader><tab>d',     '<cmd>tabclose<cr>',    'Close Tab')
  M.map('n', '<leader><tab>[',     '<cmd>tabprevious<cr>', 'Previous Tab')  
end

-- stylua: ignore
local function map_buffer()
  -- M.map('n', '<tab>', ':bnext<cr>', 'Next Buffer')
  -- M.map('n', '<s-tab>', ':bprevious<cr>', 'Previous Buffer')
  M.map('n', '<s-h>',   '<cmd>BufferLineCyclePrev<cr>', 'Previous buffer')
  M.map('n', '<s-l>',   '<cmd>BufferLineCycleNext<cr>', 'Next buffer')
  M.map('n', '<s-tab>', '<cmd>BufferLineCyclePrev<cr>', 'Previous buffer')
  M.map('n', '<tab>',   '<cmd>BufferLineCycleNext<cr>', 'Next buffer')
  M.map('n', '<leader><leader>', [[<cmd>lua require('telescope').extensions.smart_open.smart_open()<cr>]], 'Smart Open')  
end

local function map_go()
  M.map('n', '<c-p>', '<cmd>Telescope buffers show_all_buffers=true theme=get_dropdown previewer=false<cr>', 'Go To File... (telescope.nvim)')
  M.map('c', '<s-enter>', function()
    require('noice').redirect(vim.fn.getcmdline())
  end, 'Redirect Cmdline')
end

function M.setup_code()
  -- Core
  map_core()
  -- File
  map_file()
  -- Edit
  map_edit()
  -- Search
  map_search()
  -- View
  map_view()
  -- Tabs
  map_tabs()
  -- Buffer
  map_buffer()
  -- Go
  map_go()
end

local function _get_varg_front(...)
  local args = { ... }
  if vim.tbl_islist(args) and #args == 1 and type(args[1]) == 'table' then
    args = args[1]
  end
  local opts = {}
  for key, value in pairs(args) do
    opts[key] = value
  end
  return opts and opts[1] or ''
end

-- stylua: ignore
local _dap_commands = {
  { 'continue',      _dap_continue },
  { 'step_over',     function() require('dap').step_over()                                end },
  { 'step_into',     function() require('dap').step_into()                                end },
  { 'step_out',      function() require('dap').step_out()                                 end },
  { 'run_last',      function() require('dap').run_last()                                 end },
  { 'run_to_cursor', function() require('dap').run_to_cursor()                            end },
  { 'terminate',     function() require('dap').terminate()                                end },
  { 'toggle_bp',     function() require('persistent-breakpoints.api').toggle_breakpoint() end },
  { 'toggle_ui',     function() require('dapui').toggle({})                               end },
}

local function _dap_varg(args)
  local action = args.args
  for _, c in ipairs(_dap_commands) do
    if action == c[1] then
      return c[2]()
    end
  end
  base.warn(string.format('Unknown DAP Command: %s', action))
end

-- lazy\auto-session\lua\auto-session\init.lua
-- _dap_complete is used by the vimscript command for DAP completion.
-- @return table
local function _dap_complete()
  local names = {}
  for _, c in ipairs(_dap_commands) do
    table.insert(names, c[1])
  end
  return names
end

--[[
  vim.lsp.buf.hover()
  vim.lsp.buf.format()
  vim.lsp.buf.references()
  vim.lsp.buf.implementation()
  vim.lsp.buf.code_action()
]]
-- stylua: ignore
local _lsp_commands = {
  { 'hover',          vim.lsp.buf.hover          },
  { 'format',         vim.lsp.buf.format         },
  { 'references',     vim.lsp.buf.references     },
  { 'implementation', vim.lsp.buf.implementation },
  { 'code_action',    vim.lsp.buf.code_action    },
}

local function _lsp_varg(args)
  local action = args.args
  for _, c in ipairs(_lsp_commands) do
    if action == c[1] then
      return c[2]()
    end
  end
  base.warn(string.format('Unknown LSP Command: %s', action))
end

-- lazy\auto-session\lua\auto-session\init.lua
-- _lsp_complete is used by the vimscript command for LSP completion.
-- @return table
local function _lsp_complete()
  local names = {}
  for _, c in ipairs(_lsp_commands) do
    table.insert(names, c[1])
  end
  return names
end

function M.setup_comands()
  -- stylua: ignore start
  M.command('ToggleFullScreen',     _toggle_fullscreen,      'Full Screen Toggle')
  M.command('ToggleWrap',           _toggle_wrap,            'Wrap Toggle')
  M.command('ToggleList',           _toggle_showlist,        'Toggle Show List')
  M.command('ToggleFocusMode',      _toggle_focus_mode,      'Focus Mode Toggle')
  M.command('ToggleCaseSensitive',  _toggle_case_sensitive,  'Case Sensitive Toggle')
  M.command('ToggleWholeWord',      _toggle_wholeword,       'Whole Word Toggle')
  M.command('ToggleDiagnostics',    _toggle_diagnostics,     'Diagnostics Toggle')
  M.command('ToggleAutoFormat',     _toggle_autoformat,      'Auto Format Toggle')
  M.command('RemoveExclusiveORM',   _remove_exclusive_orm,   'Remove Exclusive ORM')
  M.command('CommentLine',          _comment_line,           'Comment Line')
  M.command('CommentBlock',         _comment_block,          'Comment Block')
  M.command('InsertDate',           _insert_date,            'Insert Date')
  M.command('InsertTime',           _insert_time,            'Insert Time')
  M.command('Projects',             _telescope_projects,     'Projects')
  M.command('FormatDocument',       _format_document,        'Format Document')
  -- stylua: ignore end
  -- LSP/DAP
  -- stylua: ignore start
  M.command('LSP', _lsp_varg, { complete = _lsp_complete, bang = true, nargs = '*', desc = 'LSP Command'})
  -- stylua: ignore end
end

local function _augroup(name)
  return vim.api.nvim_create_augroup('bindings_' .. name, { clear = true })
end
M.augroup = _augroup

function M.setup_autocmd()
  -- Unfold all level on open file
  vim.api.nvim_create_autocmd('BufRead', {
    group = _augroup('unfold_open'),
    pattern = { '*.c', '*.cpp', '*.cc', '*.hpp', '*.h', '*.lua' },
    callback = function()
      vim.api.nvim_create_autocmd('BufWinEnter', {
        once = true,
        command = 'normal! zx',
      })
    end,
  })

  -- Auto close noice msg-show window
  vim.api.nvim_create_autocmd('BufEnter', {
    group = _augroup('NoiceMsgShowAutoClose'),
    pattern = '*',
    callback = function()
      local layout = vim.api.nvim_call_function('winlayout', {})
      if layout[1] == 'leaf' and vim.api.nvim_buf_get_option(vim.api.nvim_win_get_buf(layout[2]), 'filetype') == 'noice' and layout[3] == nil then
        vim.cmd('confirm quit')
      end
    end,
  })

  -- Check if we need to reload the file when it changed
  local chengd_event = { 'FocusGained', 'CursorHold', 'CursorHoldI', 'TermClose', 'TermLeave' }
  -- local chengd_event = { 'FocusGained', 'BufEnter', 'CursorHold', 'CursorHoldI', 'TermClose', 'TermLeave' }
  -- Bug: neo-minimap conficts 'BufEnter' checktime
  -- https://stackoverflow.com/questions/13405959/how-do-i-get-a-list-of-the-history-of-all-the-vim-commands-i-ran
  --   In normal mode, q: will open your history in a new buffer.
  --   :history will show you a history of your commands.
  -- Bug: `q:` commond line list buffer, Fixed: by check buffer is real file.
  vim.api.nvim_create_autocmd(chengd_event, {
    group = _augroup('checktime'),
    pattern = '*',
    -- command = 'checktime',
    callback = function()
      local bufnr = vim.api.nvim_get_current_buf()
      if vim.api.nvim_buf_is_loaded(bufnr) then
        if vim.loop.fs_realpath(vim.fs.normalize(base.get_path())) then
          vim.cmd([[checktime]])
        end
      end
    end,
  })

  -- lazy\LazyVim\lua\lazyvim\config\autocmds.lua
  -- -- Check if we need to reload the file when it changed
  -- vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  --   group = _augroup("checktime"),
  --   command = "checktime",
  -- })
  -- Disable syntax for loog file
  local _disable_syntax = function()
    vim.cmd('if getfsize(@%) > 1000000 | setlocal syntax=OFF | endif')
  end
  vim.api.nvim_create_autocmd('Filetype', {
    group = _augroup('disable_syntax'),
    pattern = 'log',
    callback = function()
      _disable_syntax()
    end,
  })

  -- Close some filetypes with <q>
  vim.api.nvim_create_autocmd('FileType', {
    group = _augroup('close_with_q'),
    pattern = {
      'PlenaryTestPopup',
      'help',
      'lspinfo',
      'man',
      'notify',
      'qf',
      'spectre_panel',
      'startuptime',
      'tsplayground',
    },
    callback = function(event)
      vim.bo[event.buf].buflisted = false
      M.map('n', 'q', '<cmd>close<cr>', { buffer = event.buf })
    end,
  })

  -- Auto create dir when saving a file, in case some intermediate directory does not exist
  vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
    group = _augroup('auto_create_dir'),
    callback = function(event)
      local file = vim.loop.fs_realpath(event.match) or event.match
      vim.fn.mkdir(vim.fn.fnamemodify(file, ':p:h'), 'p')
    end,
  })

  -- Highlight on yank
  vim.api.nvim_create_autocmd('TextYankPost', {
    group = _augroup('highlight_yank'),
    callback = function()
      vim.highlight.on_yank()
    end,
  })

  -- llvm
  local llvm_ft = {
    ['.clangd'] = 'yaml',
    -- ['.clang-format'] = 'yaml', -- filetype.nvim
    -- ['_clang-format'] = 'yaml', -- filetype.nvim
    ['__config_site'] = 'cpp',
  }
  M.llvm_ft = llvm_ft
  local msvc_cpp_ft = {
    ['8859_1'] = 'cpp',
    ['8859_10'] = 'cpp',
    ['8859_13'] = 'cpp',
    ['8859_14'] = 'cpp',
    ['8859_15'] = 'cpp',
    ['8859_16'] = 'cpp',
    ['8859_2'] = 'cpp',
    ['8859_3'] = 'cpp',
    ['8859_4'] = 'cpp',
    ['8859_5'] = 'cpp',
    ['8859_6'] = 'cpp',
    ['8859_7'] = 'cpp',
    ['8859_8'] = 'cpp',
    ['8859_9'] = 'cpp',
    ['adapter'] = 'cpp',
    ['algorithm'] = 'cpp',
    ['allocators'] = 'cpp',
    ['any'] = 'cpp',
    ['array'] = 'cpp',
    ['atomic'] = 'cpp',
    ['baltic'] = 'cpp',
    ['big5'] = 'cpp',
    ['bitset'] = 'cpp',
    ['cassert'] = 'cpp',
    ['ccomplex'] = 'cpp',
    ['cctype'] = 'cpp',
    ['cerrno'] = 'cpp',
    ['cfenv'] = 'cpp',
    ['cfloat'] = 'cpp',
    ['charconv'] = 'cpp',
    ['chrono'] = 'cpp',
    ['cinttypes'] = 'cpp',
    ['ciso646'] = 'cpp',
    ['cliext'] = 'cpp',
    ['climits'] = 'cpp',
    ['clocale'] = 'cpp',
    ['cmath'] = 'cpp',
    ['codecvt'] = 'cpp',
    ['complex'] = 'cpp',
    ['condition_variable'] = 'cpp',
    ['coroutine'] = 'cpp',
    ['cp037'] = 'cpp',
    ['cp1006'] = 'cpp',
    ['cp1026'] = 'cpp',
    ['cp1250'] = 'cpp',
    ['cp1251'] = 'cpp',
    ['cp1252'] = 'cpp',
    ['cp1253'] = 'cpp',
    ['cp1254'] = 'cpp',
    ['cp1255'] = 'cpp',
    ['cp1256'] = 'cpp',
    ['cp1257'] = 'cpp',
    ['cp1258'] = 'cpp',
    ['cp424'] = 'cpp',
    ['cp437'] = 'cpp',
    ['cp500'] = 'cpp',
    ['cp737'] = 'cpp',
    ['cp775'] = 'cpp',
    ['cp850'] = 'cpp',
    ['cp852'] = 'cpp',
    ['cp855'] = 'cpp',
    ['cp856'] = 'cpp',
    ['cp857'] = 'cpp',
    ['cp860'] = 'cpp',
    ['cp861'] = 'cpp',
    ['cp862'] = 'cpp',
    ['cp863'] = 'cpp',
    ['cp864'] = 'cpp',
    ['cp865'] = 'cpp',
    ['cp866'] = 'cpp',
    ['cp869'] = 'cpp',
    ['cp874'] = 'cpp',
    ['cp875'] = 'cpp',
    ['cp932'] = 'cpp',
    ['cp936'] = 'cpp',
    ['cp949'] = 'cpp',
    ['cp950'] = 'cpp',
    ['csetjmp'] = 'cpp',
    ['csignal'] = 'cpp',
    ['cstdalign'] = 'cpp',
    ['cstdarg'] = 'cpp',
    ['cstdbool'] = 'cpp',
    ['cstddef'] = 'cpp',
    ['cstdint'] = 'cpp',
    ['cstdio'] = 'cpp',
    ['cstdlib'] = 'cpp',
    ['cstring'] = 'cpp',
    ['ctgmath'] = 'cpp',
    ['ctime'] = 'cpp',
    ['cuchar'] = 'cpp',
    ['cwchar'] = 'cpp',
    ['cwctype'] = 'cpp',
    ['cyrillic'] = 'cpp',
    ['deque'] = 'cpp',
    ['ebcdic'] = 'cpp',
    ['euc'] = 'cpp',
    ['euc_0208'] = 'cpp',
    ['exception'] = 'cpp',
    ['experimental'] = 'cpp',
    ['filesystem'] = 'cpp',
    ['forward_list'] = 'cpp',
    ['fstream'] = 'cpp',
    ['functional'] = 'cpp',
    ['future'] = 'cpp',
    ['gb12345'] = 'cpp',
    ['gb2312'] = 'cpp',
    ['generator'] = 'cpp',
    ['greek'] = 'cpp',
    ['hash_map'] = 'cpp',
    ['hash_set'] = 'cpp',
    ['iceland'] = 'cpp',
    ['initializer_list'] = 'cpp',
    ['iomanip'] = 'cpp',
    ['ios'] = 'cpp',
    ['iosfwd'] = 'cpp',
    ['iostream'] = 'cpp',
    ['istream'] = 'cpp',
    ['iterator'] = 'cpp',
    ['jis'] = 'cpp',
    ['jis_0208'] = 'cpp',
    ['jis0201'] = 'cpp',
    ['ksc5601'] = 'cpp',
    ['latin2'] = 'cpp',
    ['limits'] = 'cpp',
    ['list'] = 'cpp',
    ['locale'] = 'cpp',
    ['map'] = 'cpp',
    ['memory'] = 'cpp',
    ['memory_resource'] = 'cpp',
    ['mutex'] = 'cpp',
    ['new'] = 'cpp',
    ['numeric'] = 'cpp',
    ['one_one'] = 'cpp',
    ['optional'] = 'cpp',
    ['ostream'] = 'cpp',
    ['queue'] = 'cpp',
    ['random'] = 'cpp',
    ['ratio'] = 'cpp',
    ['regex'] = 'cpp',
    ['resumable'] = 'cpp',
    ['roman'] = 'cpp',
    ['scoped_allocator'] = 'cpp',
    ['set'] = 'cpp',
    ['shared_mutex'] = 'cpp',
    ['sjis'] = 'cpp',
    ['sjis_0208'] = 'cpp',
    ['sstream'] = 'cpp',
    ['stack'] = 'cpp',
    ['stdexcept'] = 'cpp',
    ['streambuf'] = 'cpp',
    ['string'] = 'cpp',
    ['string_view'] = 'cpp',
    ['strstream'] = 'cpp',
    ['system_error'] = 'cpp',
    ['thread'] = 'cpp',
    ['tree.txt'] = 'cpp',
    ['tuple'] = 'cpp',
    ['turkish'] = 'cpp',
    ['type_traits'] = 'cpp',
    ['typeindex'] = 'cpp',
    ['typeinfo'] = 'cpp',
    ['unordered_map'] = 'cpp',
    ['unordered_set'] = 'cpp',
    ['utf16'] = 'cpp',
    ['utf8'] = 'cpp',
    ['utf8_utf16'] = 'cpp',
    ['utility'] = 'cpp',
    ['valarray'] = 'cpp',
    ['variant'] = 'cpp',
    ['vector'] = 'cpp',
    ['wbuffer'] = 'cpp',
    ['wstring'] = 'cpp',
    ['xfacet'] = 'cpp',
    ['xhash'] = 'cpp',
    ['xiosbase'] = 'cpp',
    ['xjis'] = 'cpp',
    ['xlocale'] = 'cpp',
    ['xlocbuf'] = 'cpp',
    ['xlocinfo'] = 'cpp',
    ['xlocmes'] = 'cpp',
    ['xlocmon'] = 'cpp',
    ['xlocnum'] = 'cpp',
    ['xloctime'] = 'cpp',
    ['xmemory'] = 'cpp',
    ['xmemory0'] = 'cpp',
    ['xone_byte'] = 'cpp',
    ['xstddef'] = 'cpp',
    ['xstring'] = 'cpp',
    ['xtest'] = 'cpp',
    ['xthread'] = 'cpp',
    ['xtime'] = 'cpp',
    ['xtr1common'] = 'cpp',
    ['xtree'] = 'cpp',
    ['xtwo_byte'] = 'cpp',
    ['xutility'] = 'cpp',
    ['xxatomic'] = 'cpp',
  }
  M.msvc_cpp_ft = msvc_cpp_ft
  -- Lua implementation of the setfiletype builtin function.
  local function set_filetype(filetype)
    if vim.fn.did_filetype() == 0 then
      vim.bo.filetype = filetype
    end
  end
  local function try_lookup_setft(query, map)
    if query == nil or map == nil then
      return false
    end
    if map[query] ~= nil then
      set_filetype(map[query])
      return true
    end
    return false
  end
  -- Bug: BufReadPre make msvc_cpp_file cannot load, empty content
  vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
    group = _augroup('filetypedetect'),
    pattern = '*',
    callback = function(args)
      local name = base.name()
      try_lookup_setft(name, llvm_ft)
      if base.is_windows() then
        try_lookup_setft(name, msvc_cpp_ft)
      end
    end,
    desc = 'Filetype Detect',
  })
end

return M
