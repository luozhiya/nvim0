local dev = require('neodev')

-- IMPORTANT: make sure to setup lua-dev BEFORE lspconfig
dev.setup({
  -- add any options here, or leave empty to use the default settings
})

require('zycore.one.lsp.handler').setup()
