require('close_buffers').setup({
  preserve_window_layout = { 'this' },
  next_buffer_cmd = function(windows)
    require('bufferline').cycle(1)
    local bufnr = vim.api.nvim_get_current_buf()

    for _, window in ipairs(windows) do
      vim.api.nvim_win_set_buf(window, bufnr)
    end
  end,
})

local hardworking = require('zycore.base.hardworking')

local nnoremap = hardworking.nnoremap
local inoremap = hardworking.inoremap
local vnoremap = hardworking.vnoremap
local xnoremap = hardworking.xnoremap

-- local function close_all_except()
--   vim.cmd([[:lua require('close_buffers').delete({type = 'other'})<CR>]])
--   vim.cmd([[:redraw]])
-- end

-- vim.api.nvim_set_keymap('n', '<leader>th', [[<CMD>lua require('close_buffers').delete({type = 'hidden'})<CR>]],
--   { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('n', '<leader>tu', [[<CMD>lua require('close_buffers').delete({type = 'nameless'})<CR>]],
--   { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('n', '<leader>tc', [[<CMD>lua require('close_buffers').delete({type = 'this'})<CR>]],
--   { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('n', '<a-e>', [[<CMD>lua require('close_buffers').delete({type = 'other'})<CR>]],
--   { noremap = true, silent = true })

-- vim.keymap.set('', '<a-e>', close_all_except)

-- nnoremap('<a-e>', '<ESC>:lua require("close_buffers").delete({type="other"})<CR> ')
-- nnoremap('<a-e>', ':lua require("close_buffers").delete({type="other"}) vim.cmd([[redraw]]) <CR> ')

-- need wrap in command
vim.api.nvim_create_user_command('Only', function()
  vim.cmd([[
  :lua require("close_buffers").delete({type="other"})
  :<ESC>
  ]])
end, {})

vim.keymap.set('', '<a-e>', ':Only<CR>')
