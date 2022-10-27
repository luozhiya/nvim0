local fn = vim.fn
local opt = vim.opt
local style_constexpr = require('zycore.base.style_constexpr')
local hardworking = require('zycore.base.hardworking')

local title = {}

local function modified_icon()
  return vim.bo.modified and style_constexpr.icons.misc.circle or ''
end

title.modified_icon = modified_icon
hardworking.set(melantha, { 'zycore', 'one', 'title', 'modified_icon' }, modified_icon)

-- need global function
-- 🤣
if hardworking.is_windows() then
  opt.titlestring = ''
else
  opt.titlestring = '  %{v:lua.vim.fn.fnamemodify(v:lua.vim.fn.getcwd(), ":t")} %{v:lua.melantha.zycore.one.title.modified_icon()}'
end
opt.titleold = fn.fnamemodify(vim.loop.os_getenv('SHELL'), ':t')
opt.title = true
opt.titlelen = 80

return title
