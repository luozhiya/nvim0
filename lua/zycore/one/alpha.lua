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
  dashboard.button('f', '  Find file', ':Telescope find_files <CR>'),
  dashboard.button('e', '  New file', ':ene <CR>'),
  dashboard.button('p', '  Find project', ':Telescope projects <CR>'),
  dashboard.button('r', '  Recently used files', ':Telescope oldfiles <CR>'),
  dashboard.button('t', '  Find text', ':Telescope live_grep <CR>'),
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
