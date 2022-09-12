local fn = vim.fn
local style_constexpr = require('zycore.base.style_constexpr')
local hardworking = require('zycore.base.hardworking')
local title = {}

local function modified_icon()
  return vim.bo.modified and style_constexpr.icons.misc.circle or ''
end
title.modified_icon = modified_icon
hardworking.set(melantha, {'zycore', 'one', 'title', 'modified_icon'}, modified_icon)

-- need global function
vim.opt.titlestring = '  %{fnamemodify(getcwd(), ":t")} %{v:lua.melantha.zycore.one.title.modified_icon()}'
vim.opt.titleold = fn.fnamemodify(vim.loop.os_getenv('SHELL'), ':t')
vim.opt.title = true
vim.opt.titlelen = 70

return title
