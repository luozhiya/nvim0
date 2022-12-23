local util = require('lspconfig.util')

local function lsp_ccls_capablities(client)
  -- Lsp workspace symbol, <,lS>
  client.server_capabilities.workspaceSymbolProvider = false
  -- Lsp finder
  client.server_capabilities.definitionProvider = false  
  client.server_capabilities.referencesProvider = false
  -- 
  client.server_capabilities.implementationProvider = false
  client.server_capabilities.codeActionProvider = false
  client.server_capabilities.resolveProvider = false
  client.server_capabilities.documentSymbolProvider = false
end

local ccls_on_attach = function(client, buffer)
  require('zycore.one.lsp.handler').on_attach(client, buffer)
  lsp_ccls_capablities(client)
end

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
    ['textDocument/publishDiagnostics'] = function(...)
      return nil
    end,
    ['textDocument/hover'] = function(...)
      return nil
    end,
    ['textDocument/signatureHelp'] = function(...)
      return nil
    end,
    ['workspace/symbol'] = nil,
    ['textDocument/definition'] = nil,
    ['textDocument/implementation'] = nil,
    ['textDocument/references'] = nil,
  },
  on_attach = ccls_on_attach,
}

return opts
