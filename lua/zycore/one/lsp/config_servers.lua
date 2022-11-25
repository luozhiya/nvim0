local lsp_installer = require('nvim-lsp-installer')
local lspconfig = require('lspconfig')
local hardworking = require('zycore.base.hardworking')
local cxx_lsp = require('zycore.goforit').cxx_lsp

-- Install jsonls with nvim-lsp-installer
local servers = { 'jsonls', 'sumneko_lua', 'pyright', 'cmake', 'vimls', 'clojure_lsp' }
servers = hardworking.merge_simple_list(servers, cxx_lsp)

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

-- local ccls_workspace = {
--   workspace = {
--     applyEdit = true,
--     configuration = true,
--     -- symbolSupport = false,
--     symbol = {
--       -- support = false,
--     },
--     workspaceEdit = {
--       resourceOperations = { "rename", "create", "delete" }
--     },
--     workspaceFolders = true
--   },
--   -- workspaceSymbolProvider = nil,
-- }

for _, server in pairs(needed_setup_servers) do
  local opts = {
    on_attach = require('zycore.one.lsp.handler').on_attach,
    capabilities = require('zycore.one.lsp.handler').capabilities,
  }
  if server == 'ccls' then
    -- opts.on_attach = {}
    -- opts.on_attach = require('zycore.one.lsp.handler').ccls_on_attach
    -- opts.capabilities.workspaceSymbolProvider = false
    -- opts.capabilities = vim.tbl_deep_extend('force', opts.capabilities, ccls_workspace)
    -- print(vim.inspect(opts.capabilities))
    -- opts[capabilities][workspace][symbol] = false
  end
  local has_custom_opts, server_custom_opts = pcall(require, 'zycore.one.lsp.inject.' .. server)
  if has_custom_opts then
    opts = vim.tbl_deep_extend('force', opts, server_custom_opts)
  end
  lspconfig[server].setup(opts)
end

-- require 'lspconfig.configs'.fennel_language_server = {
--   default_config = {
--     -- replace it with true path
--     cmd = {'fennel-language-server'},
--     filetypes = {'fennel'},
--     single_file_support = true,
--     -- source code resides in directory `fnl/`
--     root_dir = lspconfig.util.root_pattern("fnl"),
--     settings = {
--       fennel = {
--         workspace = {
--           -- If you are using hotpot.nvim or aniseed,
--           -- make the server aware of neovim runtime files.
--           library = vim.api.nvim_list_runtime_paths(),
--         },
--         diagnostics = {
--           globals = {'vim'},
--         },
--       },
--     },
--   },
-- }
--
-- lspconfig.fennel_language_server.setup{}
