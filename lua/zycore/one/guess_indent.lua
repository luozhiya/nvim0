local guess_indent = require('guess-indent')

-- This is the default configuration
local opts = {
  auto_cmd = true, -- Set to false to disable automatic execution
  filetype_exclude = { -- A list of filetypes for which the auto command gets disabled
    'netrw',
    'tutor',
  },
  buftype_exclude = { -- A list of buffer types for which the auto command gets disabled
    'help',
    'nofile',
    'terminal',
    'prompt',
  },
}

guess_indent.setup(opts)
