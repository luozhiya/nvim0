local opt = require('module.options')
opt.before()
if not vim.loop.fs_stat(opt.lazy) then
  vim.fn.system({
    'git',
    'clone',
    'https://github.com/folke/lazy.nvim.git',
    opt.lazy,
  })
end
require('lazy').setup(require('module.plugins').computed(), {
  root = opt.root,
  concurrency = 2,
  defaults = { lazy = true },
  readme = { enabled = false },
  change_detection = { enabled = false },
})
opt.after()
