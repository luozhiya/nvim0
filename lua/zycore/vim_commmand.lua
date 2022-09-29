-- For custom command

vim.api.nvim_create_user_command('RemoveExclusiveORM', function()
    vim.cmd([[
  :%s/\r//g
  ]] )
end, {})
