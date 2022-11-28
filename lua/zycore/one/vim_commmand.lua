-- For custom command

vim.api.nvim_create_user_command('RemoveExclusiveORM', function()
  vim.cmd([[
  :%s/\r//g
  ]])
end, {})

-- automatic remove ^M
vim.cmd([[
augroup fmt
  autocmd!
  autocmd BufWritePre * undojoin | RemoveExclusiveORM
augroup END
]])

-- doesn't work
-- W sudo保存文件
vim.cmd([[
command W :execute ':silent w !sudo tee % > /dev/null' | :edit!
]])
