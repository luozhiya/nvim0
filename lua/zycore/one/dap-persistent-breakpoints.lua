-- print (vim.fn.stdpath('data') .. '/nvim_checkpoints')
-- /home/luozhiya/.local/share/nvim/nvim_checkpoints/

-- https://github.com/mfussenegger/nvim-dap/issues/198
require('persistent-breakpoints').setup({
  save_dir = vim.fn.stdpath('data') .. '/nvim_checkpoints',
  -- when to load the breakpoints? "BufReadPost" is recommanded.
  -- doesn't work
  load_breakpoints_event = nil,
  -- record the performance of different function. run :lua require('persistent-breakpoints.api').print_perf_data() to see the result.
  perf_record = false,
})

local function load_bps(...)
  require('persistent-breakpoints.api').load_breakpoints()
end

local group_id = vim.api.nvim_create_augroup('load_bps', { clear = true })
vim.api.nvim_create_autocmd('BufReadPost', {
  group = group_id,
  pattern = '*',
  nested = true,
  callback = function()
    load_bps()
  end,
})

-- vim.cmd([[
--   :autocmd BufReadPost * :lua require("persistent-breakpoints.api").load_breakpoints()
-- ]])

-- vim.cmd([[
--   autocmd BufRead * :lua require("persistent-breakpoints.api").load_breakpoints()
-- ]])
