local alpha = require('alpha')
local dashboard = require('alpha.themes.dashboard')

dashboard.section.header.val = {
  [[ ________     _______ ____  _____  ______ ]],
  [[|___  /\ \   / / ____/ __ \|  __ \|  ____|]],
  [[   / /  \ \_/ / |   | |  | | |__) | |__   ]],
  [[  / /    \   /| |   | |  | |  _  /|  __|  ]],
  [[ / /__    | | | |___| |__| | | \ \| |____ ]],
  [[/_____|   |_|  \_____\____/|_|  \_\______|]],
}
dashboard.section.buttons.val = {
  dashboard.button('e', '  New file', ':ene <CR>'),
  dashboard.button('f', '  Find file', ':Telescope find_files <CR>'),
  dashboard.button('p', '  Find project', ':Telescope projects <CR>'),
  dashboard.button('r', '  Recently used files', ':Telescope oldfiles <CR>'),
  dashboard.button('s', '  Find text', ':Telescope live_grep <CR>'),
  dashboard.button('u', '  Update plugins', ':PackerSync <CR>'),
  dashboard.button('t', '  Time startup', ':StartupTime <CR> <ESC>:only <CR>'), -- 羽 ⏱ 靖    福
  dashboard.button('c', '  Configuration', ':e! $MYVIMRC <CR>'),
  dashboard.button('q', '  Quit Neovim', ':qa<CR>'),
}

local function footer()
  -- NOTE: requires the fortune-mod package to work
  -- local handle = io.popen("fortune")
  -- local fortune = handle:read("*a")
  -- handle:close()
  -- return fortune
  return 'good good study, day day up'
end

dashboard.section.footer.val = footer()

dashboard.section.footer.opts.hl = 'Type'
dashboard.section.header.opts.hl = 'Include'
dashboard.section.buttons.opts.hl = 'Keyword'

dashboard.opts.opts.noautocmd = true
-- vim.cmd([[autocmd User AlphaReady echo 'ready']])
alpha.setup(dashboard.opts)

local function disable_alpha_cr()
  local buffer
  if vim.bo.ft ~= 'alpha' then
    -- buffer = vim.api.nvim_create_buf(false, true)
    -- vim.api.nvim_win_set_buf(window, buffer)
  else
    buffer = vim.api.nvim_get_current_buf()
    -- vim.api.nvim_buf_delete(buffer, {})
    vim.keymap.set('n', '<CR>', function()
      return
    end, { noremap = false, silent = true, buffer = buffer })
    vim.keymap.set('n', '<M-CR>', function()
      return
    end, { noremap = false, silent = true, buffer = buffer })
    return
  end
end

local group_id = vim.api.nvim_create_augroup('disable_alpha_cr', { clear = true })
print(group_id)
vim.api.nvim_create_autocmd('User AlphaReady', {
  group = group_id,
  pattern = '*',
  nested = true,
  callback = function()
    disable_alpha_cr()
  end,
})
