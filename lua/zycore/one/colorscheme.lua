local hardworking = require('zycore.base.hardworking')
local hl = vim.api.nvim_set_hl
local opt = vim.opt
local palette

if hardworking.is_windows() then
  -- opt.colorscheme = 'omegadark'
  vim.g.current_colorscheme = 'omegadark'
  vim.cmd([[colorscheme omegadark]])
  palette = require('omegadark.palette')
else
  -- opt.colorscheme = 'darkplus'
  vim.g.current_colorscheme = 'darkplus'
  vim.cmd([[colorscheme darkplus]])
  -- vim.api.nvim_set_var('current_colorscheme', 'darkplus')
  palette = require('darkplus.palette')
end

-- vim.cmd([[
--     let ccs = g:current_colorscheme
--     colorscheme ccs
-- ]])

-- if colorscheme == "omegadark" then
--   palette = require('omegadark.palette')
--   opt.colorscheme = colorscheme
--   opt.background = 'dark'
--   -- vim.cmd([[
--   -- try
--   --   colorscheme omegadark
--   -- catch /^Vim\%((\a\+)\)\=:E185/
--   --   colorscheme default
--   --   set background=dark
--   -- endtry
--   -- ]] )
-- else
--   palette = require('darkplus.palette')
--   -- vim.cmd([[
--   -- try
--   --   colorscheme darkplus
--   -- catch /^Vim\%((\a\+)\)\=:E185/
--   --   colorscheme default
--   --   set background=dark
--   -- endtry
--   -- ]] )
-- end

if vim.g.colors_name == 'darkplus' then
  -- local split_bg = '#131313'
  -- local split_bg = '#686868'
  local split_bg = '#3E3E3E'
  hl(0, 'NvimTreeVertSplit', { fg = split_bg, bg = split_bg })
  -- NonText listchars eol
  hl(0, 'NonText', { fg = palette.dark_gray, bg = 'NONE' })
  -- Whitespace listchars tab
  hl(0, 'Whitespace', { fg = palette.dark_gray, bg = 'NONE' })

  vim.cmd([[
    hi default LspCxxHlGroupMemberVariable ctermfg=Yellow guifg=#dcdcaa cterm=none gui=none
  ]])
else
  local split_bg = '#3E3E3E'
  hl(0, 'NvimTreeVertSplit', { fg = split_bg, bg = split_bg })
  -- NonText listchars eol
  hl(0, 'NonText', { fg = palette.dark_gray, bg = 'NONE' })
  -- Whitespace listchars tab
  hl(0, 'Whitespace', { fg = palette.dark_gray, bg = 'NONE' })

  vim.cmd([[
    hi default LspCxxHlGroupMemberVariable ctermfg=Yellow guifg=#dcdcaa cterm=none gui=none
  ]])
end

-- TODO VimScript, no l10n
vim.cmd([[
  aunmenu *
  vnoremenu PopUp.Cut                     "+x
  vnoremenu PopUp.Copy                    "+y
  anoremenu PopUp.Paste                   "+gP
  vnoremenu PopUp.Paste                   "+P
  vnoremenu PopUp.Delete                  "_x
  nnoremenu PopUp.Select\ All             ggVG
  vnoremenu PopUp.Select\ All             gg0oG$
  inoremenu PopUp.Select\ All             <C-Home><C-O>VG
  " anoremenu PopUp.-1-                     <Nop>
  " anoremenu PopUp.How-to\ disable\ mouse  <Cmd>help disable-mouse<CR>
]])

vim.cmd([[
if has('win32')
  autocmd GUIEnter * simalt ~x  " always maximize initial GUI window
  if has("directx")
    set renderoptions=type:directx
  endif
endif
" highlight Normal guibg=NONE ctermbg=None
]])

vim.opt.list = true
vim.opt.listchars = 'eol:↴'
-- vim.opt.listchars:append('space:⋅')
-- vim.opt.listchars:append('space:')
vim.opt.listchars:append('tab:<->')
