return {
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
