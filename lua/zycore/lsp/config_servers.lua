local ok, lsp_installer = pcall(require, 'nvim-lsp-installer')
if not ok then
  return
end

-- ccls
-- clangd
local hardworking = require('zycore.base.hardworking')
local cxx_lsp = require('zycore.goforit').cxx_lsp

local lspconfig = require('lspconfig')
local servers = { 'jsonls', 'sumneko_lua', 'pyright', 'cmake', 'vimls'}
servers = hardworking.merge_simple_list(servers, cxx_lsp)
--[[ hardworking.dump(servers) ]]

local ignore_setup_servers = {}
if vim.tbl_contains(cxx_lsp, 'clangd') then
  table.insert(ignore_setup_servers, 'clangd')
end

local needed_setup_servers = {}
if hardworking.empty(ignore_setup_servers) then
  needed_setup_servers = servers
else
  for _, server in pairs(servers) do
    for _, ignore in pairs(ignore_setup_servers) do
      if server ~= ignore then
        table.insert(needed_setup_servers, server)
      end
    end
  end
end

lsp_installer.setup({
  ensure_installed = needed_setup_servers,
})

for _, server in pairs(needed_setup_servers) do
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
