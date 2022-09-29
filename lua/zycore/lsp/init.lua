local ok, _ = pcall(require, 'lspconfig')
if not ok then
  return
end

require('zycore.lsp.config_servers')
require('zycore.lsp.handler').setup()
-- After LSP
local clangd_extensions = require('zycore.one.clangd_extensions')

