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
  -- 'cmp', -- managed by packer
  'format',
  'formatter_nvim',
  -- 'comment', -- managed by packer
  -- 'treesitter', -- managed by packer
  'autocommands',
  'nvim_tree',
  'which_key',
  'sqlite',
  -- 'telescope_setup', -- managed by packer
  -- 'telescope', -- managed by packer
  'illuminate',
  'lualine',
  'bufferline',
  -- 'nvim_autopairs', -- managed by packer
  'toggleterm',
  'project',
  'indent_blankline',
  'alpha',
  -- 'gitsigns', -- managed by packer
  'dap_nvim',
  'dapui',
  'trim',
  'wrapping',
  'number',
  'guess_indent',
  -- 'null_ls', -- managed by packer
  -- 'lua_dev', -- managed by packer
  'colorizer',
  -- 'aerial', -- managed by packer
  -- 'lsp_signature_nvim', -- managed by packer
  'trouble',
  'close_buffer_nvim',
  'ouroboros',
  -- 'hotpot_nvim',
  -- 'fidget_nvim', -- managed by packer
  -- 'neogit_nvim', -- managed by packer
  -- 'lsp_lines_nvim', -- managed by packer
  'true_zen',
  'matchparen_nvim',
  'nvim_spectre',
  'nvim_bqf',
  'nvim_pqf',
  'easy_align',

  -- LSP
  -- 'clangd_extensions', -- managed by packer
  -- 'lsp', -- managed by packer
  -- 'nvim_lightbulb', -- managed by packer

  -- UI/Misc
  'vim_commmand',
  'title',
  'client_ui',
  'fontface',
}

for k, v in pairs(features_list) do
  require('zycore.one.' .. v)
end
