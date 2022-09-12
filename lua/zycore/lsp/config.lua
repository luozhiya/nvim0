local ok, lsp_installer = pcall(require, 'nvim-lsp-installer')
if not ok then
  return
end

local lspconfig = require('lspconfig')
local servers = { 'jsonls', 'sumneko_lua', 'pyright', 'ccls', 'cmake', 'vimls' }

lsp_installer.setup({
  ensure_installed = servers,
})

for _, server in pairs(servers) do
  local opts = {
    on_attach = require('zycore.lsp.handler').on_attach,
    capabilities = require('zycore.lsp.handler').capabilities,
  }
  local has_custom_opts, server_custom_opts = pcall(require, 'zycore.lsp.inject.' .. server)
  if has_custom_opts then
    opts = vim.tbl_deep_extend('force', opts, server_custom_opts)
  end
  lspconfig[server].setup(opts)
end
