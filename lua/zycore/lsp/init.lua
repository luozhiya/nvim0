local ok, _ = pcall(require, 'lspconfig')
if not ok then
  return
end

require('zycore.lsp.config_servers')
require('zycore.lsp.handler').setup()
require('zycore.lsp.null_ls')
