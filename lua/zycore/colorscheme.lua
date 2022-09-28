-- require('vscode').change_style('dark')
vim.cmd([[
try
  colorscheme darkplus
catch /^Vim\%((\a\+)\)\=:E185/
  colorscheme default
  set background=dark
endtry
]])

local hl = vim.api.nvim_set_hl
local split_bg = "#686868"
hl(0, "NvimTreeVertSplit", { fg = split_bg, bg = split_bg })
