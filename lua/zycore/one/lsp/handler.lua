local hardworking = require('zycore.base.hardworking')

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
    virtual_text = true,
    -- show signs
    signs = true,
    update_in_insert = true,
    underline = true,
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
end

local function lsp_highlight_document(client)
  -- Set autocommands conditional on server_capabilities
  local ok, illuminate = pcall(require, 'illuminate')
  if not ok then
    return
  end
  illuminate.on_attach(client)
end

local function lsp_outline(client)
  local ok, aerial = pcall(require, 'aerial')
  if not ok then
    return
  end
  aerial.on_attach(client)
end

local function lsp_signature(buffer)
  local ok, signature = pcall(require, 'lsp_signature')
  if not ok then
    return
  end
  local opts = {}
  signature.on_attach(opts, buffer)
end

local function lsp_keymaps(buffer)
  local opts = { noremap = true, silent = true }
  local bkeymap = function(buf, lhs, rhs)
    vim.api.nvim_buf_set_keymap(buf, 'n', lhs, rhs, opts)
  end
  bkeymap(buffer, 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>')
  bkeymap(buffer, 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>')
  bkeymap(buffer, 'K', '<cmd>lua vim.lsp.buf.hover()<CR>')
  bkeymap(buffer, 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>')
  bkeymap(buffer, 'gs', '<cmd>lua vim.lsp.buf.signature_help()<CR>')
  bkeymap(buffer, 'gr', '<cmd>lua vim.lsp.buf.references()<CR>')
  bkeymap(buffer, '[d', '<cmd>lua vim.diagnostic.goto_prev({ border = "rounded" })<CR>')
  bkeymap(buffer, 'gl', '<cmd>lua vim.diagnostic.open_float({ border = "rounded" })<CR>')
  bkeymap(buffer, ']d', '<cmd>lua vim.diagnostic.goto_next({ border = "rounded" })<CR>')
  -- bkeymap(buffer, "<leader>q", "<cmd>lua vim.diagnostic.setloclist()<CR>")
  vim.cmd([[ command! Format execute 'lua vim.lsp.buf.format{async=true}' ]])
end

M.on_attach = function(client, buffer)
  lsp_keymaps(buffer)
  lsp_highlight_document(client)
  lsp_outline(client)
  lsp_signature(buffer)
end

local capabilities = vim.lsp.protocol.make_client_capabilities()

local cmp_ok, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
if not cmp_ok then
  return
end

M.capabilities = cmp_nvim_lsp.update_capabilities(capabilities)

return M
