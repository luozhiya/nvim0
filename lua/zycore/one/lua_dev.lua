local dev_ok, dev = pcall(require, 'lua-dev')
if not dev_ok then
    return
end
-- IMPORTANT: make sure to setup lua-dev BEFORE lspconfig
dev.setup({
  -- add any options here, or leave empty to use the default settings
})

