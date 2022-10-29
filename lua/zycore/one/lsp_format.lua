local format = require('lsp-format')
local lsp = require('lspconfig')

format.setup({
  typescript = {
    tab_width = function()
      return vim.opt.shiftwidth:get()
    end,
  },
  yaml = { tab_width = 2 },
})
-- local prettier = {
--   formatCommand = [[prettier --stdin-filepath ${INPUT} ${--tab-width:tab_width}]],
--   formatStdin = true,
-- }
-- lsp.efm.setup({
--   on_attach = require('lsp-format').on_attach,
--   init_options = { documentFormatting = true },
--   settings = {
--     languages = {
--       typescript = { prettier },
--       yaml = { prettier },
--     },
--   },
-- })

vim.cmd([[cabbrev w execute "Format sync" <bar> w]])
