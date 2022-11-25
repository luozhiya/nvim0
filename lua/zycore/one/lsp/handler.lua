local cmp_nvim_lsp = require('cmp_nvim_lsp')
local style = require('zycore.base.style_constexpr')
local bnnoremap = require('zycore.base.hardworking').bnnoremap

local M = {}

M.setup = function()
  local signs = {
    { name = 'DiagnosticSignError', text = '' },
    { name = 'DiagnosticSignWarn', text = '' },
    { name = 'DiagnosticSignHint', text = '' },
    { name = 'DiagnosticSignInfo', text = '' },
  }

  for _, sign in ipairs(signs) do
    vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = '' })
  end

  local config = {
    -- disable virtual text
    virtual_text = false,
    -- virtual_text = {
    --   prefix = style.icons.misc.circle,
    --   only_current_line = true,
    -- },
    -- show signs
    signs = false,
    update_in_insert = false,
    underline = false,
    severity_sort = true,
    float = {
      focusable = false,
      style = 'minimal',
      border = 'rounded',
      source = 'always',
      header = '',
      prefix = '',
    },
  }

  vim.diagnostic.config(config)

  vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = 'rounded',
    width = 60,
  })

  vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = 'rounded',
    width = 60,
  })

  -- vim.lsp.handlers['workspace/symbol'] = nil
end

local function lsp_highlight_document(client)
  -- Set autocommands conditional on server_capabilities
  local illuminate = require('illuminate')
  illuminate.on_attach(client)
end

local function lsp_outline(client)
  -- local aerial = require('aerial')
  -- aerial.on_attach(client)
end

local function lsp_signature(buffer)
  local signature = require('lsp_signature')
  local opts = {}
  signature.on_attach(opts, buffer)
end

local function lsp_keymaps(buffer)
  bnnoremap(buffer, 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>')
  bnnoremap(buffer, 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>')
  bnnoremap(buffer, 'K', '<cmd>lua vim.lsp.buf.hover()<CR>')
  bnnoremap(buffer, 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>')
  bnnoremap(buffer, 'ge', '<cmd>lua vim.lsp.buf.signature_help()<CR>')
  bnnoremap(buffer, 'gr', '<cmd>lua vim.lsp.buf.references()<CR>')
  bnnoremap(buffer, '[d', '<cmd>lua vim.diagnostic.goto_prev({ border = "rounded" })<CR>')
  bnnoremap(buffer, 'gl', '<cmd>lua vim.diagnostic.open_float(0, { scope="line", source="always", border = "rounded" })<CR>')
  -- bnnoremap(buffer, 'gl', '<cmd>lua vim.diagnostic.open_float(0, {scope="cursor",source="always", border = "rounded", format=function(diag) return string.format("%s (%s)", diag.message, diag.code or (diag.user_data and diag.  user_data.lsp and diag.user_data.lsp.code)) end})<CR>')
  bnnoremap(buffer, ']d', '<cmd>lua vim.diagnostic.goto_next({ border = "rounded" })<CR>')
  -- bnnoremap(buffer, "<leader>q", "<cmd>lua vim.diagnostic.setloclist()<CR>")
  vim.cmd([[ command! Format execute 'lua vim.lsp.buf.format{async=true}' ]])
end

M.on_attach = function(client, buffer)
  lsp_keymaps(buffer)
  lsp_highlight_document(client)
  lsp_outline(client)
  lsp_signature(buffer)
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
M.capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
-- print(vim.inspect(capabilities))
-- print('-------------------------')
-- print(vim.inspect(M.capabilities))

return M
