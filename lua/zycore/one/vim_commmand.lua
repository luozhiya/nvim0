-- For custom command

vim.api.nvim_create_user_command('RemoveExclusiveORM', function()
  vim.cmd([[
  :%s/\r//g
  ]])
end, {})

-- automatic remove ^M
vim.cmd([[
augroup fixorm
  autocmd!
  autocmd BufWritePre * undojoin | RemoveExclusiveORM
augroup END
]])

vim.api.nvim_create_user_command('FixLf', function()
  vim.cmd([[
  :setl ff=unix fixeol
  ]])
end, {})

vim.cmd([[
augroup fixeol
  autocmd!
  autocmd BufWritePre * undojoin | FixLf
augroup END
]])

-- doesn't work
-- W sudo保存文件
vim.cmd([[
command W :execute ':silent w !sudo tee % > /dev/null' | :edit!
]])
