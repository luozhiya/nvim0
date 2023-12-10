local base = require('base')
local bindings = require('module.bindings')
local M = {}
local run = {}

run['Start Screen'] = {
  ['goolord/alpha-nvim'] = {
    event = 'VimEnter',
    config = function()
      local dashboard = require('alpha.themes.dashboard')
      dashboard.section.header.val = {
        -- [[           good good study, day day up           ]],
      }
      dashboard.section.buttons.val = bindings.alpha()
      for _, button in ipairs(dashboard.section.buttons.val) do
        button.opts.hl = 'AlphaButtons'
        button.opts.hl_shortcut = 'AlphaShortcut'
      end
      dashboard.section.header.opts.hl = 'AlphaHeader'
      dashboard.section.buttons.opts.hl = 'AlphaButtons'
      dashboard.section.footer.opts.hl = 'AlphaFooter'
      dashboard.opts.layout[1].val = 2

      local alpha = require('alpha')
      alpha.setup(dashboard.config)

      vim.api.nvim_create_autocmd('User', {
        pattern = 'LazyVimStarted',
        callback = function()
          local stats = require('lazy').stats()
          local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
          dashboard.section.footer.val = '⚡ Neovim loaded ' .. stats.count .. ' plugins in ' .. ms .. 'ms'
          pcall(alpha.redraw)
        end,
      })
    end,
  },
}

run['Columns And Lines'] = {
  ['nvim-lualine/lualine.nvim'] = {
    event = { 'BufNewFile', 'BufReadPost', 'CmdlineEnter' },
    config = function()
      local icons = require('module.options').icons
      local _lsp_active = function()
        local names = {}
        local bufnr = vim.api.nvim_get_current_buf()
        for _, client in pairs(vim.lsp.get_active_clients({ bufnr = bufnr })) do
          table.insert(names, client.name)
        end
        -- return vim.tbl_isempty(names) and '' or table.concat(names, ' ')
        -- return vim.tbl_isempty(names) and '' or icons.collects.Tomatoes .. table.concat(names, ' ')
        return 'LSP<' .. table.concat(names, ', ') .. '>'
      end
      local _location = function()
        return string.format('%3d:%-2d', vim.fn.line('.'), vim.fn.virtcol('.'))
        -- return string.format('%3d:%-2d ', vim.fn.line('.'), vim.fn.virtcol('.')) .. icons.collects.Pagelines
      end
      local _fg = function(name)
        return function()
          local hl = vim.api.nvim_get_hl_by_name(name, true)
          return hl and hl.foreground and { fg = string.format('#%06x', hl.foreground) }
        end
      end
      local _osv = function()
        return require('osv').is_running() and 'OSV Running' or ''
      end
      local fileformat = { 'fileformat', icons_enabled = false }
      local _diff_source = function()
        local gitsigns = vim.b.gitsigns_status_dict
        if gitsigns then
          return {
            added = gitsigns.added,
            modified = gitsigns.changed,
            removed = gitsigns.removed,
          }
        end
      end
      local _trunc = function(trunc_width, trunc_len, hide_width, no_ellipsis)
        return function(str)
          local win_width = vim.fn.winwidth(0)
          if hide_width and win_width < hide_width then
            return ''
          elseif trunc_width and trunc_len and win_width < trunc_width and #str > trunc_len then
            return str:sub(1, trunc_len) .. (no_ellipsis and '' or '...')
          end
          return str
        end
      end
      --function for optimizing the search count
      local _search_count = function()
        if vim.api.nvim_get_vvar('hlsearch') == 1 then
          local res = vim.fn.searchcount({ maxcount = 999, timeout = 500 })
          if res.total > 0 then
            return string.format(icons.collects.Search .. '%d/%d', res.current, res.total)
          end
        end
        return ''
      end
      local _macro_reg = function()
        return vim.fn.reg_recording()
      end
      local _indentation = function()
        local indentation_type = 'Tabs:'
        if vim.api.nvim_buf_get_option(0, 'expandtab') then
          indentation_type = 'Spaces:'
        end
        return indentation_type .. vim.o.ts
      end
      local _encoding = function()
        return string.upper(vim.bo.fileencoding)
      end
      local git_blame = require('gitblame')
      local opts = {
        options = {
          section_separators = '',
          component_separators = '',
          theme = 'tokyonight', -- catppuccin auto tokyonight
          globalstatus = true,
          disabled_filetypes = { statusline = { 'dashboard', 'alpha' } },
        },
        sections = {
          lualine_a = { 'mode', { _macro_reg, type = 'lua_expr', color = 'WarningMsg' } },
          lualine_b = {
            'branch',
            {
              'diff',
              source = _diff_source,
              symbols = {
                added = icons.git.added,
                modified = icons.git.modified,
                removed = icons.git.removed,
              },
            },
            { _search_count, type = 'lua_expr' },
          },
          lualine_c = {
            {
              'diagnostics',
              symbols = {
                error = icons.diagnostics.Error,
                warn = icons.diagnostics.Warn,
                info = icons.diagnostics.Info,
                hint = icons.diagnostics.Hint,
              },
              colored = true,
              update_in_insert = false,
              always_visible = false,
              -- sources = { 'nvim_diagnostic', 'nvim_lsp' },
              -- sources = { 'nvim_lsp' },
              sources = { 'nvim_diagnostic' },
              sections = { 'error', 'warn' },
              -- sections = { 'error' },
            },
            -- { 'filetype', icon_only = true, separator = '', padding = { left = 1, right = 0 } },
            -- { 'filename', path = 1, symbols = { modified = '  ', readonly = '', unnamed = '' } },
            -- stylua: ignore
            -- {
            --   function() return require("nvim-navic").get_location() end,
            --   cond = function() return package.loaded["nvim-navic"] and require("nvim-navic").is_available() end,
            -- },
            -- { git_blame.get_current_blame_text, cond = git_blame.is_blame_text_available },
          },
          lualine_x = {
            -- stylua: ignore
            {
              function() return require("noice").api.status.command.get() end,
              cond = function() return package.loaded["noice"] and require("noice").api.status.command.has() end,
              color = _fg("Statement")
            },
            -- stylua: ignore
            -- {
            --   function() return require("noice").api.status.mode.get() end,
            --   cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
            --   color = _fg("Constant") ,
            -- },
            -- { require('lazy.status').updates, cond = require('lazy.status').has_updates, color = _fg('Special') },
            'ctime',
            _lsp_active,
            _encoding,
            _indentation,
            {
              'fileformat',
              symbols = {
                unix = 'LF',
                dos = 'CRLF',
                mac = 'CR',
              },
            },
            {
              'filetype',
              icons_enabled = false,
            },
          },
          lualine_z = { _location },
        },
        extensions = { 'neo-tree', 'nvim-tree', 'lazy' },
      }
      require('lualine').setup(opts)
    end,
  },
  ['Bekaboo/dropbar.nvim'] = {
    event = { 'BufReadPost', 'BufNewFile' },
    config = function()
      require('dropbar').setup({})
    end,
  },
  ['b0o/incline.nvim'] = {
    event = { 'BufReadPost', 'BufNewFile' },
    config = function()
      local colors = require('tokyonight.colors').setup()
      local opts = {
        debounce_threshold = {
          falling = 50,
          rising = 10,
        },
        hide = {
          cursorline = true,
          focused_win = false,
          only_win = false,
        },
        highlight = {
          groups = {
            InclineNormal = { guibg = '#FC56B1', guifg = colors.black },
            InclineNormalNC = { guifg = '#FC56B1', guibg = colors.black },
          },
        },
        window = { margin = { vertical = 0, horizontal = 1 } },
        render = function(props)
          local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ':t')
          return { { filename } }
          -- local icon, color = require('nvim-web-devicons').get_icon_color(filename)
          -- return { { icon }, { ' ' }, { filename } }
          -- return { { os.date('%H:%M:%S', os.time()) } }
          -- local icon, hl = require('nvim-web-devicons').get_icon_by_filetype(element.filetype, { default = false })
          -- return icon, hl
        end,
      }
      require('incline').setup(opts)
    end,
  },
  ['akinsho/bufferline.nvim'] = {
    event = { 'BufNewFile', 'BufReadPre' },
    config = function()
      local bufferline = require('bufferline')
      local opts = {
        options = {
          mode = 'buffers', -- set to "tabs" to only show tabpages instead
          style_preset = bufferline.style_preset.default, -- or bufferline.style_preset.minimal,
          themable = true, -- allows highlight groups to be overriden i.e. sets highlights as default
          numbers = 'both', -- "none" | "ordinal" | "buffer_id" | "both" | function({ ordinal, id, lower, raise }): string,
          close_command = function(bufnum)
            -- require('close_buffers').delete({ type = bufnum })
            require('bufdelete').bufdelete(bufnum, true)
          end,
          right_mouse_command = false, -- can be a string | function | false, see "Mouse actions"
          left_mouse_command = 'buffer %d', -- can be a string | function, | false see "Mouse actions"
          middle_mouse_command = nil, -- can be a string | function, | false see "Mouse actions"
          max_name_length = 22,
          max_prefix_length = 15, -- prefix used when a buffer is de-duplicated
          truncate_names = true, -- whether or not tab names should be truncated
          tab_size = 22,
          -- diagnostics = false,
          diagnostics = 'nvim_lsp',
          -- close_command = 'bdelete! %d',
          -- left_mouse_command = 'buffer %d',
          -- right_mouse_command = 'bdelete! %d',
          separator_style = 'slant', -- slope thick thin slant
          always_show_bufferline = true,
          diagnostics_indicator = function(_, _, diag)
            local icons = require('module.options').icons.diagnostics
            local ret = (diag.error and icons.Error .. diag.error .. ' ' or '') .. (diag.warning and icons.Warn .. diag.warning or '')
            -- local ret = (diag.error and icons.Error .. diag.error .. ' ' or '')
            return vim.trim(ret)
          end,
          offsets = {
            {
              filetype = 'NvimTree',
              text = 'File Explorer',
              highlight = 'Directory',
              separator = true,
              text_align = 'left',
            },
            {
              filetype = 'neo-tree',
              text = 'EXPLORER',
              highlight = 'Directory',
              separator = true,
              text_align = 'left',
            },
          },
          -- ---@alias bufferline.IconFetcherOpts {directory: boolean, path: string, extension: string, filetype: string?}
          get_element_icon = function(element)
            -- element consists of {filetype: string, path: string, extension: string, directory: string}
            -- This can be used to change how bufferline fetches the icon
            -- for an element e.g. a buffer or a tab.
            local name = vim.fn.fnamemodify(element.path, ':t')
            local filetype = bindings.msvc_cpp_ft[name]
            if filetype then
              local icon, hl = require('nvim-web-devicons').get_icon_by_filetype(filetype, { default = false })
              return icon, hl
            end
          end,
          show_buffer_icons = true, -- disable filetype icons for buffers
        },
      }
      bufferline.setup(opts)
    end,
  },
}

run['Colorschemes'] = {
  ['folke/tokyonight.nvim'] = {
    lazy = false,
    priority = 1000,
    config = function()
      local util = require('tokyonight.util')
      local opts = {
        style = 'moon',
        -- transparent = true,
        styles = {
          -- Style to be applied to different syntax groups
          -- Value is any valid attr-list value for `:help nvim_set_hl`
          comments = { italic = true },
          keywords = { italic = false },
          functions = {},
          variables = {},
          -- Background styles. Can be "dark", "transparent" or "normal"
          sidebars = 'dark', -- transparent -- style for sidebars, see below
          floats = 'dark', -- transparent -- style for floating windows
        },
        sidebars = {
          'qf',
          'vista_kind',
          'terminal',
          'spectre_panel',
          'startuptime',
          'Outline',
        },
        on_highlights = function(hl, c)
          hl.CursorLineNr = { fg = c.orange, bold = true }
          hl.LineNr = { fg = c.orange, bold = true }
          hl.LineNrAbove = { fg = c.fg_gutter }
          hl.LineNrBelow = { fg = c.fg_gutter }

          -- Telescope
          local prompt = '#2d3149'
          hl.TelescopeNormal = { bg = c.bg_dark, fg = c.fg_dark }
          hl.TelescopeBorder = { bg = c.bg_dark, fg = c.bg_dark }
          hl.TelescopePromptNormal = { bg = prompt }
          hl.TelescopePromptBorder = { bg = prompt, fg = prompt }
          hl.TelescopePromptTitle = { bg = c.fg_gutter, fg = c.orange }
          hl.TelescopePreviewTitle = { bg = c.bg_dark, fg = c.bg_dark }
          hl.TelescopeResultsTitle = { bg = c.bg_dark, fg = c.bg_dark }

          -- mfussenegger/nvim-treehopper
          hl.TSNodeKey = { bold = true, fg = c.orange }
          -- hl.TSNodeUnmatched = { fg = '#587539' }

          -- phaazon/hop.nvim
          -- https://github.com/phaazon/hop.nvim/issues/154
          -- What is your colorscheme? Some colorschemes override Hop colors.
          hl.HopNextKey = { fg = c.orange, bold = true }
          hl.HopNextKey1 = { fg = c.blue2, bold = true }
          hl.HopNextKey2 = { fg = util.darken(c.blue2, 0.6) }
          hl.HopUnmatched = { fg = c.dark3 }

          -- No italic
          -- lazy\neo-tree.nvim\lua\neo-tree\ui\highlights.lua
          --   M.GIT_UNTRACKED = "NeoTreeGitUntracked"
          --   M.create_highlight_group(M.GIT_UNTRACKED, {}, nil, conflict.foreground, "italic")
          -- #5d9a73  vscode
          -- #ff8700  neotree
          hl.NeoTreeGitUntracked = { fg = '#5d9a73' }
          -- VSCode dark modified color
          hl.NeoTreeGitModified = { fg = '#d6b462' }
        end,
      }
      require('tokyonight').setup(opts)
      if base.is_kernel() then
        vim.cmd([[colorscheme tokyonight]])
      else
        vim.cmd([[colorscheme tokyonight]])
        -- vim.cmd([[colorscheme tokyonight-day]])
      end
      -- Disabling spellchecker highlight
      -- https://vi.stackexchange.com/questions/33116/disabling-spellchecker-highlight
      -- Do `:filter Spell highlight` to see the list of highlight groups related to spell checking.
      vim.cmd([[
        highlight clear SpellBad
        highlight clear SpellCap
        highlight clear SpellRare
        highlight clear SpellLocal
      ]])
    end,
  },
}

run['Builtin UI Improved'] = {
  ['stevearc/dressing.nvim'] = {
    event = { 'User NeXT' },
    config = function()
      local opts = {
        input = {
          enabled = true,
          prompt_align = 'center',
          relative = 'editor',
          prefer_width = 0.6,
          win_options = { winblend = 0 },
        },
        select = { enabled = true, backend = { 'telescope' } },
      }
      require('dressing').setup(opts)
    end,
  },
  ['folke/noice.nvim'] = {
    -- enabled = false,
    -- cond = false,
    event = { 'User NeXT' },
    config = function()
      local opts = {
        cmdline = {
          -- enabled = false,
          enabled = true, -- enables the Noice cmdline UI
          -- Allow cmdline in popup
          -- 1. no bug in %s
          view = 'cmdline_popup', -- view for rendering the cmdline. Change to `cmdline` to get a classic cmdline at the bottom -- cmdline_popup
          -- opts = {}, -- global options for the cmdline. See section on views
          format = {
            cmdline = false,
            lua = false, -- to disable a format, set to `false`
            search_down = false,
            search_up = false,
            filter = false,
            help = false,
            input = {}, -- Used by input()
            -- conceal = false,
            -------------------------------------------------------------------------
            -- conceal: (default=true) This will hide the text in the cmdline that matches the pattern.
            -- view: (default is cmdline view)
            -- opts: any options passed to the view
            -- icon_hl_group: optional hl_group for the icon
            -- title: set to anything or empty string to hide
            -------------------------------------------------------------------------
            cmdline = { pattern = '^:', icon = '', lang = 'vim' },
            search_down = { kind = 'search', pattern = '^/', icon = ' ', lang = 'regex' },
            search_up = { kind = 'search', pattern = '^%?', icon = ' ', lang = 'regex' },
            filter = { pattern = '^:%s*!', icon = '$', lang = 'bash' },
            lua = { pattern = { '^:%s*lua%s+', '^:%s*lua%s*=%s*', '^:%s*=%s*' }, icon = '', lang = 'lua' },
            help = { pattern = '^:%s*he?l?p?%s+', icon = '' },
          },
        },
        -- wilder
        popupmenu = {
          enabled = true, -- enables the Noice popupmenu UI
          ---@type 'nui'|'cmp'
          backend = 'nui', -- backend to use to show regular cmdline completions
          -- Icons for completion item kinds (see defaults at noice.config.icons.kinds)
          kind_icons = {}, -- set to `false` to disable icons
        },
        messages = {
          -- NOTE: If you enable messages, then the cmdline is enabled automatically.
          -- This is a current Neovim limitation.
          enabled = true,
          view = 'notify', -- default view for messages
          view_error = 'notify', -- view for errors
          view_warn = 'notify', -- view for warnings
          view_history = 'messages', -- view for :messages
          view_search = 'virtualtext', -- virtualtext -- view for search count messages. Set to `false` to disable
        },
        lsp = {
          hover = {
            enabled = true,
            silent = true, -- set to true to not show a message if hover is not available
            -- view = nil, -- hover/popup/messages/mini/cmdline_output -- when nil, use defaults from documentation
            view = 'hover',
            -- ---@type NoiceViewOptions
            -- opts = {}, -- merged with defaults from documentation
            -- lazy/noice.nvim/lua/noice/config/views.lua
            --   M.defaults["hover"] = opts
            opts = {
              -- view = "popup",
              relative = 'cursor',
              zindex = 45,
              enter = false,
              anchor = 'auto',
              size = {
                width = 'auto',
                height = 'auto',
                max_height = 20,
                max_width = 120,
              },
              border = {
                style = 'rounded',
                padding = { 0, 1 },
                -- style = "none",
                -- padding = { 0, 2 },
              },
              position = { row = 1, col = 0 },
              win_options = {
                wrap = true,
                linebreak = true,
              },
            },
          },
          progress = {
            enabled = true,
            -- -- Lsp Progress is formatted using the builtins for lsp_progress. See config.format.builtin
            -- -- See the section on formatting for more details on how to customize.
            -- --- @type NoiceFormat|string
            format = 'lsp_progress',
            -- --- @type NoiceFormat|string
            format_done = 'lsp_progress_done',
            throttle = 1000 / 30, -- frequency to update lsp progress message
            view = 'mini',
          },
          signature = {
            enabled = false,
            -- auto_open = {
            --   enabled = true,
            --   trigger = true, -- Automatically show signature help when typing a trigger character from the LSP
            --   luasnip = true, -- Will open signature help when jumping to Luasnip insert nodes
            --   throttle = 50, -- Debounce lsp signature help request by 50ms
            -- },
            -- view = nil, -- when nil, use defaults from documentation
            -- ---@type NoiceViewOptions
            -- opts = {}, -- merged with defaults from documentation
          },
          -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
          -- lazy\noice.nvim\lua\noice\lsp\override.lua
          override = {
            -- override the default lsp markdown formatter with Noice
            ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
            -- override the lsp markdown formatter with Noice
            ['vim.lsp.util.stylize_markdown'] = true,
            -- override cmp documentation with Noice (needs the other options to work)
            ['cmp.entry.get_documentation'] = true,
          },
          -- Messages shown by lsp servers
          message = {
            enabled = true,
            view = 'notify',
            opts = {},
          },
          -- defaults for hover and signature help
          documentation = {
            view = 'hover',
            ---@type NoiceViewOptions
            opts = {
              lang = 'markdown',
              replace = true,
              render = 'plain',
              format = { '{message}' },
              win_options = { concealcursor = 'n', conceallevel = 3 },
            },
          },
        },
        notify = {
          -- Noice can be used as `vim.notify` so you can route any notification like other messages
          -- Notification messages have their level and other properties set.
          -- event is always "notify" and kind can be any log level as a string
          -- The default routes will forward notifications to nvim-notify
          -- Benefit of using Noice for this is the routing and consistent history view
          enabled = true,
          -- view = 'mini',
          view = 'notify',
        },
        redirect = {
          view = 'popup',
          filter = { event = 'msg_show' },
        },
        routes = {
          {
            filter = {
              event = 'msg_show',
              find = '%d+L, %d+B',
            },
            view = 'mini',
          },
          -- Route mini.ai to mini
          -- Bug: cmdline need updated?
          {
            filter = {
              event = 'msg_show',
              find = '(mini.align)',
            },
            view = 'mini', -- cmdline
          },
          {
            filter = {
              event = 'msg_show',
              find = '(Quick Words)',
            },
            view = 'mini',
          },
        },
        presets = {
          bottom_search = true, -- use a classic bottom cmdline for search
          command_palette = true, -- position the cmdline and popupmenu together
          long_message_to_split = true, -- long messages will be sent to a split
          inc_rename = true, -- enables an input dialog for inc-rename.nvim
          lsp_doc_border = true, -- add a border to hover docs and signature help
          -- https://github.com/folke/noice.nvim/issues/517
          -- fix(config): properly deal with preset routes. Fixes #517
          -- https://github.com/folke/noice.nvim/commit/fea7f1cf15b04ec9b8dd071aa3510f693156ce59
          cmdline_output_to_split = false, -- show `msg-show` in split bottom window
        },
        commands = {
          -- all = {
          --   -- options for the message history that you get with `:Noice`
          --   view = 'split',
          --   opts = { enter = true, format = 'details' },
          --   filter = {},
          -- },
          history = {
            -- options for the message history that you get with `:Noice`
            view = 'split',
            opts = { enter = true, format = 'details' },
            filter = {
              any = {
                { event = 'notify' },
                { error = true },
                { warning = true },
                { event = 'msg_show', kind = { '' } },
                { event = 'lsp', kind = 'message' },
              },
            },
          },
          -- :Noice last
          last = {
            view = 'popup',
            opts = { enter = true, format = 'details' },
            filter = {
              any = {
                { event = 'notify' },
                { error = true },
                { warning = true },
                { event = 'msg_show', kind = { '' } },
                { event = 'lsp', kind = 'message' },
              },
            },
            filter_opts = { count = 1 },
          },
          -- :Noice errors
          errors = {
            -- options for the message history that you get with `:Noice`
            view = 'popup',
            opts = { enter = true, format = 'details' },
            filter = { error = true },
            filter_opts = { reverse = true },
          },
        },
        -- markdown = {
        --   hover = {
        --     ['|(%S-)|'] = vim.cmd.help, -- vim help links
        --     ['%[.-%]%((%S-)%)'] = require('noice.util').open, -- markdown links
        --   },
        --   highlights = {
        --     ['|%S-|'] = '@text.reference',
        --     ['@%S+'] = '@parameter',
        --     ['^%s*(Parameters:)'] = '@text.title',
        --     ['^%s*(Return:)'] = '@text.title',
        --     ['^%s*(See also:)'] = '@text.title',
        --     ['{%S-}'] = '@parameter',
        --   },
        -- },
        format = {
          level = {
            icons = false,
          },
        },
        throttle = 1000 / 60,
      }

      local lazyredraw = vim.opt.lazyredraw
      vim.opt.lazyredraw = false
      require('noice').setup(opts)
      vim.opt.lazyredraw = lazyredraw

      -- moving the cursor during substitute does not update the cmdline ui
      -- 🪓 we do vim.api.nvim_input("<space><bs>") during substitute to force a redraw
      -- I was able to fix this for Noice by calling update_screen() with ffi
      -- I only call that code during substitute and when the cmdline cursor is not at the end of the cmdline, to prevent flickering.
      -- https://github.com/folke/noice.nvim/issues/6
      -- https://github.com/neovim/neovim/issues/20463#issuecomment-1317594168
      -- Ref: lua\noice\util\hacks.lua
      --[[
        local was_in_cmdline = false
        function M.cmdline_force_redraw()
          local ffi = require("noice.util.ffi")
          local pos = vim.fn.getcmdpos()
          local in_cmdline = pos < #vim.fn.getcmdline() + 1
          if ffi.cmdpreview and (in_cmdline or was_in_cmdline) then
            was_in_cmdline = in_cmdline
            -- HACK: this will trigger redraw during substitute and cmdpreview,
            -- but when moving the cursor, the screen will be cleared until
            -- a new character is entered
            ffi.update_screen()
          end
          if vim.api.nvim_get_mode().mode == "c" and vim.fn.getcmdline():find("s/") then
            -- HACK: this will trigger redraw during substitue
            vim.api.nvim_input("<space><bs>")
          end  
        end        
      ]]
      -- local Hacks = require('noice.util.hacks')
      -- local function cmdline_force_redraw()
      --   local ffi = require('noice.util.ffi')
      --   if ffi.cmdpreview then
      --     -- HACK: this will trigger redraw during substitute and cmdpreview,
      --     -- but when moving the cursor, the screen will be cleared until
      --     -- a new character is entered
      --     ffi.update_screen()
      --   end
      --   if vim.api.nvim_get_mode().mode == 'c' and vim.fn.getcmdline():find('s/') then
      --     -- HACK: this will trigger redraw during substitue
      --     vim.api.nvim_input('<space><bs>')
      --   end
      -- end
      -- Hacks.cmdline_force_redraw = cmdline_force_redraw
    end,
  },
}

run['File Explorer'] = {
  -- Neovim plugin to manage the file system and other tree like structures.
  -- Wiki
  -- https://github.com/nvim-neo-tree/neo-tree.nvim/wiki/Recipes/7258eb737ec3277056da74b16e2305ed78920488
  ['nvim-neo-tree/neo-tree.nvim'] = {
    event = 'VeryLazy',
    cmd = { 'Neotree' },
    config = function()
      vim.g.neo_tree_remove_legacy_commands = 1
      local opts = {
        source_selector = {
          winbar = true, -- toggle to show selector on winbar
          statusline = true, -- toggle to show selector on statusline
          show_scrolled_off_parent_node = true, -- boolean
        },
        enable_git_status = true,
        enable_diagnostics = false,
        -- async_directory_scan = 'never',
        -- log_level = 'trace',
        -- log_to_file = false,
        close_if_last_window = true,
        filesystem = {
          bind_to_cwd = true,
          follow_current_file = true,
          hijack_netrw_behavior = 'open_default', -- "open_current",  -- "disabled",
        },
        default_component_configs = {
          modified = {
            symbol = 'M', -- 
            highlight = 'NeoTreeModified',
          },
          name = {
            trailing_slash = false,
            use_git_status_colors = true,
            highlight = 'NeoTreeFileName',
          },
          git_status = {
            symbols = {
              -- Change type
              added = '✚', -- or "✚", but this is redundant info if you use git_status_colors on the name
              modified = '', -- or "", but this is redundant info if you use git_status_colors on the name
              deleted = '✖', -- this can only be used in the git_status source
              renamed = '', -- this can only be used in the git_status source
              -- Status type
              untracked = '', -- 
              ignored = '', -- 
              unstaged = '', -- 
              staged = '', -- 
              conflict = '', -- 
            },
          },
          indent = {
            with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
            expander_collapsed = '',
            expander_expanded = '',
            expander_highlight = 'NeoTreeExpander',
          },
        },
        -- A list of functions, each representing a global custom command
        -- that will be available in all sources (if not overridden in `opts[source_name].commands`)
        -- see `:h neo-tree-global-custom-commands`
        commands = {},
        window = {
          position = 'left',
          width = 40,
        },
      }
      opts = vim.tbl_deep_extend('error', opts, bindings.neotree())
      require('neo-tree').setup(opts)
    end,
  },
}

run['Window Management'] = {
  ['mrjones2014/smart-splits.nvim'] = {
    config = function()
      require('smart-splits').setup({})
    end,
  },
}

run['Project'] = {
  ['ahmedkhalf/project.nvim'] = {
    config = function()
      require('project_nvim').setup({
        silent_chdir = true,
      })
    end,
  },
}

run['Session'] = {
  ['folke/persistence.nvim'] = {
    event = 'BufReadPre',
    config = function()
      require('persistence').setup()
    end,
  },
}

run['Fuzzy Finder'] = {
  ['nvim-telescope/telescope.nvim'] = {
    cmd = { 'Telescope' },
    config = function()
      local telescope = require('telescope')
      local actions = require('telescope.actions')
      local previewers = require('telescope.previewers')
      local _new_maker = function(filepath, bufnr, opts)
        opts = opts or {}
        filepath = vim.fn.expand(filepath)
        vim.loop.fs_stat(filepath, function(_, stat)
          if not stat then
            return
          end
          if stat.size > 100000 then
            return
          else
            previewers.buffer_previewer_maker(filepath, bufnr, opts)
          end
        end)
      end
      local dir = base.to_native(vim.fn.stdpath('config') .. '/local')
      vim.fn.mkdir(dir, 'p')
      local opts = {
        defaults = {
          prompt_prefix = ' ',
          selection_caret = ' ',
          buffer_previewer_maker = _new_maker,
          file_ignore_patterns = { 'node_modules', '%_files/*.html', '%_cache', '.git/', 'site_libs', '.venv' },
          layout_strategy = 'flex',
          sorting_strategy = 'ascending',
          layout_config = {
            prompt_position = 'top',
          },
          history = {
            path = base.to_native(dir .. '/telescope_history.sqlite3'),
            limit = 100,
          },
        },
        pickers = {
          buffers = {
            ignore_current_buffer = false,
            sort_lastused = true,
            sort_mru = true,
          },
          find_files = {
            hidden = true,
            find_command = {
              'rg',
              '--no-ignore',
              '--files',
              '--hidden',
              '--glob',
              '!.git/*',
              '--glob',
              '!**/.Rproj.user/*',
              '-L',
            },
          },
        },
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
        },
      }
      opts = vim.tbl_deep_extend('error', opts, bindings.telescope())
      telescope.setup(opts)
      telescope.load_extension('undo')
      telescope.load_extension('live_grep_args')
      telescope.load_extension('projects')
      telescope.load_extension('ui-select')
      vim.cmd([[autocmd User TelescopePreviewerLoaded setlocal wrap]])
    end,
  },
}

run['Bindings'] = {
  ['folke/which-key.nvim'] = {
    event = { 'VeryLazy' },
    config = function()
      local wk = require('which-key')
      wk.setup()
      bindings.wk(wk)
    end,
  },
}

run['Buffer'] = {
  ['kazhala/close-buffers.nvim'] = {
    cmd = { 'BWipeout', 'BDelete' },
  },
  -- Delete buffers and close files in Vim without closing your windows or messing up your layout.
  ['moll/vim-bbye'] = {
    -- event = { 'Bdelete', 'Bwipeout' },
  },
}

run['Mini Family'] = {
  -- Bug: client + noice + mini.align = Break
  ['echasnovski/mini.align'] = {
    keys = { { 'gma' }, { 'gmA' } },
    config = function()
      local opts = {}
      opts = vim.tbl_deep_extend('error', opts, bindings.opts['mini.align'])
      require('mini.align').setup(opts)
    end,
  },
  ['echasnovski/mini.bufremove'] = {
    keys = { { '<leader>bd' }, { '<leader>bD' } },
  },
  ['echasnovski/mini.pairs'] = {
    config = function()
      require('mini.pairs').setup()
    end,
  },
  ['echasnovski/mini.surround'] = {
    event = { 'BufReadPost', 'BufNewFile', 'InsertEnter' },
    config = function()
      local opts = {}
      opts = vim.tbl_deep_extend('error', opts, bindings.opts['mini.surround'])
      require('mini.surround').setup(opts)
    end,
  },
}

run['Sematic Structure'] = {
  -- Nvim Treesitter configurations and abstraction layer
  ['nvim-treesitter/nvim-treesitter'] = {
    cmd = { 'TSInstall', 'TSBufEnable', 'TSBufDisable', 'TSModuleInfo', 'TSUpdate' },
    build = ':TSUpdate',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      --[[
        A parser can also be loaded manually using a full path:
        vim.treesitter.language.add('python', { path = "/path/to/python.so" })
      ]]
      local path = require('base').to_native(vim.fn.stdpath('config') .. '/parsers')
      local opts = {
        ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
        -- ./parsers/parser/c.so
        -- nvim/lib/nvim/parser/c.so -- remove this old version in ArchLinux
        -- %LOCALAPPDATA%/nvim-data
        parser_install_dir = path, -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!
        -- https://github.com/nvim-treesitter/nvim-treesitter#supported-languages
        ensure_installed = {
          'bash',
          'fish',
          'c',
          'cmake',
          'cpp',
          -- 'haskell',
          -- 'html',
          -- 'javascript',
          -- 'json',
          'lua',
          'luadoc',
          'markdown_inline',
          'markdown',
          'python',
          'query', -- Neovim Treesitter Playground
          'regex',
          -- 'rust',
          -- 'typescript',
          'vim',
          'vimdoc',
          -- 'yaml',
        },
        highlight = { enable = true },
        indent = {
          enable = true,
          disable = { 'cpp' },
        },
        playground = {
          enable = true,
          disable = {},
          updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
          persist_queries = false, -- Whether the query persists across vim sessions
          keybindings = {
            toggle_query_editor = 'o',
            toggle_hl_groups = 'i',
            toggle_injected_languages = 't',
            toggle_anonymous_nodes = 'a',
            toggle_language_display = 'I',
            focus_language = 'f',
            unfocus_language = 'F',
            update = 'R',
            goto_node = '<cr>',
            show_help = '?',
          },
        },
      }
      opts = vim.tbl_deep_extend('error', opts, bindings.ts())
      vim.opt.runtimepath:append(path)
      require('nvim-treesitter.configs').setup(opts)
    end,
  },
}

run['Matching'] = {
  --[[
    Even better % navigate and highlight matching words modern matchit and matchparen.
      Supports both vim and neovim + tree-sitter.
    Overview
      %  close word       cycle back to the corresponding open word
         recognized word  go forwards to next matching word
         not on a word    seek forwards
      Adds motions g%, [%, ]%, and z%
      Combines these motions into convenient text objects i% and a%
      Highlights symbols and words under the cursor which % can work on, and highlights matching symbols and words.
        call s:init_option('matchup_matchparen_start_sign', '▶')
        call s:init_option('matchup_matchparen_end_sign', '◀')
  ]]
  ['andymass/vim-matchup'] = {
    -- enabled = false,
    -- event = { 'BufReadPost', 'BufNewFile' },
    config = function()
      vim.g.matchup_matchparen_offscreen = { method = 'status_manual' }
      -- Tree-sitter integration
      -- local opts = {
      --   matchup = {
      --     enable = true, -- mandatory, false will disable the whole extension
      --     disable = { "lua", "ruby" },  -- optional, list of language that will be disabled
      --   },
      -- }
      -- require('nvim-treesitter.configs').setup(opts)
    end,
  },
}

run['Surround'] = {
  -- Add/change/delete surrounding delimiter pairs with ease.
  ['kylechui/nvim-surround'] = {
    --[[
      The three "core" operations of add/delete/change can be done with the keymaps ys{motion}{char}, ds{char}, 
        and cs{target}{replacement}, respectively. 
      For the following examples, * will denote the cursor position:
          Old text                    Command         New text
      ----------------------------------------------------------------------
          surr*ound_words             ysiw)           (surround_words)
          *make strings               ys$"            "make strings"
          [delete ar*ound me!]        ds]             delete around me!
          remove <b>HTML t*ags</b>    dst             remove HTML tags
          'change quot*es'            cs'"            "change quotes"
          <b>or tag* types</b>        csth1<CR>       <h1>or tag types</h1>
          delete(functi*on calls)     dsf             function calls
    ]]
    event = { 'BufReadPost', 'BufNewFile', 'InsertEnter' },
    config = function()
      require('nvim-surround').setup({
        -- Configuration here, or leave empty to use defaults
      })
    end,
  },
}

run['Indent'] = {
  ['lukas-reineke/indent-blankline.nvim'] = {
    event = { 'BufReadPost', 'BufNewFile' },
    config = function()
      local highlight = {
        'RainbowRed',
        'RainbowYellow',
        'RainbowBlue',
        'RainbowOrange',
        'RainbowGreen',
        'RainbowViolet',
        'RainbowCyan',
      }
      local hooks = require('ibl.hooks')
      -- create the highlight groups in the highlight setup hook, so they are reset
      -- every time the colorscheme changes
      hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
        vim.api.nvim_set_hl(0, 'RainbowRed', { fg = '#E06C75' })
        vim.api.nvim_set_hl(0, 'RainbowYellow', { fg = '#E5C07B' })
        vim.api.nvim_set_hl(0, 'RainbowBlue', { fg = '#61AFEF' })
        vim.api.nvim_set_hl(0, 'RainbowOrange', { fg = '#D19A66' })
        vim.api.nvim_set_hl(0, 'RainbowGreen', { fg = '#98C379' })
        vim.api.nvim_set_hl(0, 'RainbowViolet', { fg = '#C678DD' })
        vim.api.nvim_set_hl(0, 'RainbowCyan', { fg = '#56B6C2' })
      end)
      require('ibl').setup({ indent = { highlight = highlight } })
    end,
  },
}

run['Alignment'] = {
  -- A Vim alignment plugin
  ['junegunn/vim-easy-align'] = {
    cmd = { 'EasyAlign' },
  },
  -- Neovim plugin for aligning text
  ['RRethy/nvim-align'] = {
    cmd = { 'Align' },
  },
}

run['Formatting'] = {
  ['mhartington/formatter.nvim'] = {
    cmd = { 'FormatWriteLock' },
    config = function()
      require('formatter').setup({
        logging = false,
        filetype = {
          lua = { require('formatter.filetypes.lua').stylua },
          ['*'] = {
            require('formatter.filetypes.any').remove_trailing_whitespace,
          },
        },
      })
    end,
  },
}

run['Comment'] = {
  ['numToStr/Comment.nvim'] = {
    config = function()
      local opts = {
        pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
        mappings = {
          ---Operator-pending mapping; `gcc` `gbc` `gc[count]{motion}` `gb[count]{motion}`
          basic = false,
          ---Extra mapping; `gco`, `gcO`, `gcA`
          extra = false,
        },
      }
      require('Comment').setup(opts)
    end,
  },
}

run['Todo'] = {
  ['folke/todo-comments.nvim'] = {
    event = { 'BufReadPost', 'BufNewFile' },
    config = function()
      require('todo-comments').setup()
    end,
  },
}

run['Completion'] = {
  ['hrsh7th/nvim-cmp'] = {
    event = { 'InsertEnter', 'CmdlineEnter' },
    dependencies = {
      'hrsh7th/cmp-cmdline',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-emoji',
    },
    config = function()
      local fmt_presets = {
        vscode = {
          format = require('lspkind').cmp_format({
            symbol_map = require('module.options').icons.kinds,
            mode = 'symbol_text',
            maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
            -- The function below will be called before any actual modifications from lspkind
            -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
            before = function(entry, vim_item)
              local str = require('cmp.utils.str')
              -- vim_item.word = str.trim(vim_item.word)
              vim_item.abbr = str.trim(vim_item.abbr) -- clangd lsp 1 more space front.
              vim_item.abbr = ' ' .. vim_item.abbr
              return vim_item
            end,
            menu = {
              nvim_lsp = '[LSP]',
              luasnip = '[Snippet]',
              nvim_lua = '[API]',
              buffer = '[Buffer]',
              path = '[Path]',
              emoji = '[Emoji]',
              dictionary = '[Dictionary]',
            },
          }),
        },
      }
      local cmp = require('cmp')
      -- For instance, you can set the `buffer`'s source `group_index` to a larger number
      -- if you don't want to see `buffer` source items while `nvim-lsp` source is available:
      local sources_presets = {
        dict = {
          { name = 'nvim_lsp', group_index = 1 },
          { name = 'luasnip', group_index = 1 },
          { name = 'buffer', group_index = 1 },
          {
            name = 'dictionary',
            keyword_length = 2,
            group_index = 1,
          },
          { name = 'path', group_index = 1 },
          { name = 'emoji', group_index = 1 },
        },
        all = {
          { name = 'nvim_lsp', group_index = 1 },
          { name = 'luasnip', group_index = 1 },
          { name = 'buffer', group_index = 1 },
          {
            name = 'dictionary',
            keyword_length = 4,
            group_index = 1,
          },
          { name = 'path', group_index = 1 },
          { name = 'emoji', group_index = 1 },
        },
        queue = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
        }, {
          { name = 'nvim_lua' },
        }, {
          { name = 'buffer' },
          { name = 'path' },
          { name = 'emoji' },
        }, {
          {
            name = 'dictionary',
            keyword_length = 3,
          },
        }),
      }
      local opts = {
        completion = {
          completeopt = 'menuone,noselect,noinsert',
        },
        sources = sources_presets.all,
        snippet = {
          -- REQUIRED - you must specify a snippet engine
          expand = function(args)
            require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
          end,
        },
        sorting = {
          comparators = {
            cmp.config.compare.offset,
            cmp.config.compare.exact,
            cmp.config.compare.score,
            function(...)
              return require('cmp_buffer'):compare_locality(...)
            end,
            function(...)
              return require('cmp-under-comparator').under(...)
            end,
            cmp.config.compare.kind,
            cmp.config.compare.sort_text,
            cmp.config.compare.length,
            cmp.config.compare.order,
          },
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        formatting = fmt_presets.vscode,
        experimental = {
          ghost_text = {
            hl_group = 'LspCodeLens',
          },
        },
      }
      opts = vim.tbl_deep_extend('error', opts, bindings.cmp())
      cmp.setup(opts)

      -- Set configuration for specific filetype.
      -- For short dict keyword length
      cmp.setup.filetype({ 'markdown' }, {
        sources = sources_presets.dict,
      })

      -- Enable `(` insertion after select function or method item
      local cmp_autopairs = require('nvim-autopairs.completion.cmp')
      cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())

      local md_opts = vim.tbl_deep_extend('error', {}, bindings.cmp(false))
      cmp.setup.filetype('markdown', md_opts)

      cmp.setup.cmdline(':', {
        completion = {
          completeopt = 'menuone,noselect,noinsert',
        },
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = 'path' },
          { name = 'cmdline', option = { ignore_cmds = { 'Man', '!' } } },
        }),
      })
      cmp.setup.cmdline('/', {
        completion = {
          completeopt = 'menuone,noselect,noinsert',
        },
        mapping = cmp.mapping.preset.cmdline(),
        sources = { { name = 'buffer' } },
      })
    end,
  },
}

run['C++'] = {
  ['p00f/godbolt.nvim'] = {
    cmd = { 'Godbolt' },
    config = function()
      local opts = {
        languages = {
          cpp = { compiler = 'clangdefault', options = {} },
          c = { compiler = 'cclangdefault', options = {} },
        }, -- vc2017_64
        url = 'http://localhost:10240', -- https://godbolt.org
        quickfix = {
          enable = false, -- whether to populate the quickfix list in case of errors
          auto_open = false, -- whether to open the quickfix list in case of errors
        },
      }
      require('godbolt').setup(opts)
    end,
  },
}

run['Diagnostics'] = {
  ['folke/trouble.nvim'] = {
    cmd = { 'TroubleToggle' },
    config = function()
      local opts = { use_diagnostic_signs = true, icons = true }
      require('trouble').setup(opts)
    end,
  },
}

run['LSP'] = {
  ['neovim/nvim-lspconfig'] = {
    -- ft = { 'c', 'cpp', 'lua' },
    event = { 'BufReadPre' },
    config = require('module.lsp').lsp,
  },
  ['DNLHC/glance.nvim'] = {
    cmd = { 'Glance' },
    config = function()
      local opts = {
        border = {
          enable = true,
          top_char = '―',
          bottom_char = '―',
        },
        hooks = {
          before_open = function(results, open, jump, method)
            if #results == 1 then
              jump(results[1])
            else
              open(results)
            end
          end,
        },
      }
      require('glance').setup(opts)
    end,
  },
}

run['Storage'] = {
  ['kkharji/sqlite.lua'] = {
    config = function()
      if require('base').is_windows() then
        local nvim = 'nvim.exe'
        vim.g.sqlite_clib_path = string.sub(vim.loop.exepath(nvim), 1, -(#nvim + 1)) .. 'sqlite3.dll'
      end
    end,
  },
}

local cached = {}
M.spec = function(item)
  if vim.tbl_isempty(cached) then
    for _, v in pairs(run) do
      cached = vim.tbl_deep_extend('error', cached, v)
    end
  end
  local key = nil
  if item[1] then
    key = item[1]
  elseif item['name'] then
    key = item['name']
  end
  return vim.tbl_deep_extend('error', item, cached[key] or {})
end
return M
