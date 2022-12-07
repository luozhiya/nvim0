local cmp = require('cmp')

local opts = {
  completion = { completeopt = 'menu,menuone,noinsert' },
  formatting = require('zycore.one.cmp_base').wbthomason,
}

cmp.setup(opts)

cmp.setup.cmdline('/', {
  sources = { { name = 'buffer' } },
  mapping = cmp.mapping.preset.cmdline({}),
})

cmp.setup.cmdline(':', {
  sources = cmp.config.sources({ { name = 'path' } }, { { name = 'cmdline' } }),
  mapping = cmp.mapping.preset.cmdline({}),
})
