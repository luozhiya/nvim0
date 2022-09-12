local vnoremap = function(lhs, rhs)
  vim.api.nvim_set_keymap('v', lhs, rhs, opts)
end
