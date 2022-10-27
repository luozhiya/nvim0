local null_ls = require('null-ls')
local formatting = null_ls.builtins.formatting
local diagnostics = null_ls.builtins.diagnostics

local opts = {
  debug = true,
  on_attach = function(client)
    if client.server_capabilities.document_formatting then
      vim.cmd([[
            augroup LspFormatting
                autocmd! * <buffer>
                autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_seq_sync()
            augroup END
            ]])
    end
  end,
  sources = {
    formatting.prettier.with({
      filetypes = { 'html', 'json', 'yaml', 'markdown' },
      extra_args = { '--no-semi', '--single-quote', '--jsx-single-quote' },
    }),
    formatting.black.with({ extra_args = { '--fast' } }),
    formatting.stylua,
  },
}

null_ls.setup(opts)
