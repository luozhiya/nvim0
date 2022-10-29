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
  -- 'vim_bbye', -- managed by packer
  -- 'cmp', -- managed by packer
  -- 'format', -- managed by packer
  -- 'formatter', -- managed by packer
  -- 'comment', -- managed by packer
  -- 'treesitter', -- managed by packer
  'autocommands',
  -- 'nvim_tree', -- managed by packer
  'which_key',
  -- 'sqlite', -- managed by packer
  -- 'telescope_setup', -- managed by packer
  -- 'telescope', -- managed by packer
  -- 'illuminate',
  'lualine',
  'bufferline',
  -- 'nvim_autopairs', -- managed by packer
  'toggleterm',
  -- 'project',
  -- 'indent_blankline', -- managed by packer
  'alpha',
  -- 'gitsigns', -- managed by packer
  -- 'dap_nvim', -- managed by packer
  -- 'dapui', -- managed by packer
  -- 'trim', -- managed by packer
  -- 'wrapping', -- managed by packer
  'number',
  -- 'guess_indent', -- managed by packer
  -- 'null_ls', -- managed by packer
  -- 'lua_dev', -- managed by packer
  -- 'colorizer', -- managed by packer
  -- 'aerial', -- managed by packer
  -- 'lsp_signature_nvim', -- managed by packer
  -- 'trouble', -- managed by packer
  -- 'close_buffer', -- managed by packer
  -- 'ouroboros',
  -- 'hotpot_nvim',
  -- 'fidget_nvim', -- managed by packer
  -- 'neogit_nvim', -- managed by packer
  -- 'lsp_lines_nvim', -- managed by packer
  -- 'true_zen', -- managed by packer
  -- 'matchparen_nvim', -- managed by packer
  -- 'nvim_spectre', -- managed by packer
  -- 'nvim_bqf', -- managed by packer
  -- 'nvim_pqf', -- managed by packer
  -- 'easy_align', -- managed by packer

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
