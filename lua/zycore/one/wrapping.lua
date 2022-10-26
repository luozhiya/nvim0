local wrapping = require('wrapping')
local hardworking = require('zycore.base.hardworking')

local opts = {
  auto_set_mode_heuristically = true,
}

wrapping.setup(opts)

-- if hardworking.is_linux() then
--   wrapping.hard_wrap_mode()
-- end

local swap_wrap = function()
  if vim.opt.wrap._value == true then
    vim.opt.wrap = false
    wrapping.hard_wrap_mode()
  else
    wrapping.soft_wrap_mode()
    vim.opt.wrap = true
  end
end

vim.api.nvim_create_user_command('SwapWrap', function()
  swap_wrap()
end, {})

vim.keymap.set('', '<a-q>', ':SwapWrap<CR>')

-- vim.keymap.set("n", "yw", function()
--     wrapping.toggle_wrap_mode()
-- end)
