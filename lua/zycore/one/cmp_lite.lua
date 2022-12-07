local cmp = require('cmp')

cmp.setup({})

cmp.setup.cmdline('/', {
  sources = { { name = 'buffer' } },
  mapping = cmp.mapping.preset.cmdline({}),
})

cmp.setup.cmdline(':', {
  sources = cmp.config.sources({ { name = 'path' } }, { { name = 'cmdline' } }),
  mapping = cmp.mapping.preset.cmdline({}),
})
