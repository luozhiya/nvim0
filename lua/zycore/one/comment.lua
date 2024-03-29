local comment = require('Comment')

local opts = {
  ---Add a space b/w comment and the line
  padding = true,
  ---Whether the cursor should stay at its position
  sticky = true,
  ---Lines to be ignored while (un)comment
  ignore = nil,
  ---LHS of toggle mappings in NORMAL mode
  toggler = {
    ---Line-comment toggle keymap
    line = 'gcc',
    ---Block-comment toggle keymap
    block = 'gbc',
  },
  ---LHS of operator-pending mappings in NORMAL and VISUAL mode
  opleader = {
    ---Line-comment keymap
    line = 'gc',
    ---Block-comment keymap
    block = 'gb',
  },
  ---LHS of extra mappings
  extra = {
    ---Add comment on the line above
    above = 'gcO',
    ---Add comment on the line below
    below = 'gco',
    ---Add comment at the end of line
    eol = 'gcA',
  },
  ---Enable keybindings
  ---NOTE: If given `false` then the plugin won't create any mappings
  mappings = {
    ---Operator-pending mapping; `gcc` `gbc` `gc[count]{motion}` `gb[count]{motion}`
    basic = true,
    ---Extra mapping; `gco`, `gcO`, `gcA`
    extra = true,
    ---Extended mapping; `g>` `g<` `g>[count]{motion}` `g<[count]{motion}`
    extended = false,
  },
  -- Function to call before (un)comment
  -- pre_hook = nil,
  -- pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
  pre_hook = function(ctx)
    local U = require('Comment.utils')

    local location = nil
    if ctx.ctype == U.ctype.blockwise then
      location = require('ts_context_commentstring.utils').get_cursor_location()
    elseif ctx.cmotion == U.cmotion.v or ctx.cmotion == U.cmotion.V then
      location = require('ts_context_commentstring.utils').get_visual_start_location()
    end

    local key = nil
    key = ctx.ctype == U.ctype.linewise and '__default' or '__multiline'

    return require('ts_context_commentstring.internal').calculate_commentstring({
      key = key,
      location = location,
    })
  end,

  ---Function to call after (un)comment
  post_hook = nil,
}

comment.setup(opts)

-- local opts = { noremap = true, silent = true }
-- local keymap = vim.api.nvim_set_keymap
-- local nnoremap = function(lhs, rhs)
--     vim.api.nvim_set_keymap('n', lhs, rhs, opts)
-- end
-- nnoremap("<C-\\>", "gcc")

local dash = '--%s'
local dash_bracket = '--[[%s]]'
local ft = require('Comment.ft')
-- Set only line comment
ft.lua = dash

vim.cmd([[
" xnoremap <A-\> gcc
nmap <A-\> gcc
vmap <A-\> gc
" imap <A-\> <ESC>:gcc
]])
