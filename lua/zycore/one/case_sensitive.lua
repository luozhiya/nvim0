local nnoremap = require('zycore.base.hardworking').nnoremap

local case_sensitive = function()
  if vim.opt.ignorecase._value == true then
    vim.opt.ignorecase = false
  else
    vim.opt.ignorecase = true
  end
end

vim.api.nvim_create_user_command('CaseSensitive', function()
  case_sensitive()
end, {})

nnoremap('<a-c>', ':CaseSensitive<CR>')

-- vim.cmd([[
-- nnoremap<leader>/ /\<\><left><left>  
-- ]])
