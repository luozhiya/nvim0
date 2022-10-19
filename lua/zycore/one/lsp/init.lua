local ok, _ = pcall(require, 'lspconfig')
if not ok then
  return
end

require('zycore.one.lsp.config_servers')
require('zycore.one.lsp.handler').setup()
