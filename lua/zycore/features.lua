local features_list = {
  -- Basic
  'option',
  'colorscheme',

  -- First needed
  'impatient',
  'notify_nvim',

  -- Packer
  'packer_nvim_setup',

  -- Basic
  'keymap',

  -- Plugin
  'sneak',
  'vim_bbye',
  'cmp',
  'format',
  'formatter_nvim',
  -- 'comment', -- managed by packer
  'treesitter',
  'autocommands',
  'nvim_tree',
  'which_key',
  'sqlite',
  -- 'telescope', -- managed by packer
  'illuminate',
  'lualine',
  'bufferline',
  'nvim_autopairs',
  'toggleterm',
  'project',
  'indent_blankline',
  'alpha',
  'gitsigns',
  'dap_nvim',
  'dapui',
  'trim',
  'wrapping',
  'number',
  'guess_indent',
  'null_ls',
  'lua_dev',
  'colorizer',
  'aerial',
  'lsp_signature_nvim',
  'trouble',
  'close_buffer_nvim',
  'ouroboros',
  -- 'hotpot_nvim',
  'fidget_nvim',
  'neogit_nvim',
  'lsp_lines_nvim',
  'true_zen',
  'matchparen_nvim',
  'nvim_spectre',
  'nvim_bqf',
  'nvim_pqf',
  'easy_align',

  -- LSP
  'clangd_extensions',
  'lsp',

  -- UI/Misc
  'vim_commmand',
  'title',
  'client_ui',
  'fontface',
}

for k, v in pairs(features_list) do
  require('zycore.one.' .. v)
end
