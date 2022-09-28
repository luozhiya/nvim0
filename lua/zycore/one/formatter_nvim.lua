-- mhartington/formatter.nvim

-- Utilities for creating configurations
local util_ok, util = pcall(require, 'formatter.util')
if not util_ok then
  return
end

local opts = {
  -- Enable or disable logging
  logging = true,
  -- Set the log level
  log_level = vim.log.levels.DEBUG,
  -- All formatter configurations are opt-in
  filetype = {
    -- Formatter configurations for filetype "lua" go here
    -- and will be executed in order
    lua = {
      -- "formatter.filetypes.lua" defines default configurations for the
      -- "lua" filetype
      -- require('formatter.filetypes.lua').stylua,

      -- You can also define your own configuration
      function()
        -- Supports conditional formatting
        -- if util.get_current_buffer_file_name() == 'special.lua' then
        --   return nil
        -- end

        -- Full specification of configurations is down below and in Vim help
        -- files
        return {
          exe = 'stylua1',
          args = {
            '--search-parent-directories',
            '--stdin-filepath',
            util.escape_path(util.get_current_buffer_file_path()),
            '--',
            '-',
          },
          stdin = true,
        }
      end,
    },

    -- Use the special "*" filetype for defining formatter configurations on
    -- any filetype
    ['*'] = {
      -- "formatter.filetypes.any" defines default configurations for any
      -- filetype
      -- require('formatter.filetypes.any').remove_trailing_whitespace,
    },
  },
}

-- Provides the Format, FormatWrite, FormatLock, and FormatWriteLock commands
local fmt = require('formatter')

require('formatter').setup(opts)

vim.cmd([[
" nnoremap <silent> <leader>X :Format<CR>
" nnoremap <silent> <leader>x :FormatWrite<CR>
" augroup FormatAutogroup
"   autocmd!
"   autocmd BufWritePost * FormatWrite
" augroup END

" augroup FormatAutogroup
"   autocmd!
"   autocmd User FormatterPre lua print "This will print before formatting"
"   autocmd User FormatterPost lua print "This will print after formatting"
" augroup END
]])
