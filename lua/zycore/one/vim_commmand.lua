-- For custom command

vim.api.nvim_create_user_command('RemoveExclusiveORM', function()
  vim.cmd([[
  :%s/\r//g
  ]])
end, {})

vim.api.nvim_create_user_command('Only', function()
  vim.cmd([[
  :lua require("close_buffers").delete({type="other"}) 
  ]])
end, {})
