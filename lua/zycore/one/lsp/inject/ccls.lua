local util = require('lspconfig.util')

local opts = {
  default_config = {
    cmd = { 'ccls' },
    filetypes = { 'c', 'cpp', 'objc', 'objcpp' },
    root_dir = util.root_pattern('compile_commands.json', '.ccls', '.git'),
    offset_encoding = 'utf-32',
    -- ccls does not support sending a null root directory
    single_file_support = false,
  },
  init_options = {
    highlight = { lsRanges = true },
    cache = {
      directory = '/tmp/ccls-cache',
    },
    compilationDatabaseDirectory = 'build',
    index = {
      threads = 0,
    },
    clang = {
      excludeArgs = { '-frounding-math' },
    },
  },
  handlers = {
    -- ['textDocument/publishDiagnostics'] = function(...)
    --   return nil
    -- end,
    ['textDocument/hover'] = function(...)
      return nil
    end,
    ['textDocument/signatureHelp'] = function(...)
      return nil
    end,
  },
}

return opts
