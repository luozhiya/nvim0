local ok, _ = pcall(require, "lspconfig")
if not ok then
  return
end

require "zycore.lsp.config"
require("zycore.lsp.handler").setup()
require "zycore.lsp.null-ls"

