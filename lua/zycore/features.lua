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
  'comment', -- managed by packer
  'treesitter',
  'autocommands',
  'nvim_tree',
  'which_key',
  'sqlite',
  -- 'telescope_setup', -- managed by packer
  -- 'telescope', -- managed by packer
  'illuminate',
  'lualine',
  'bufferline',
  -- 'nvim_autopairs',
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
  -- 'neogit_nvim', -- managed by packer
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
  'nvim_lightbulb',

  -- UI/Misc
  'vim_commmand',
  'title',
  'client_ui',
  'fontface',
}

for k, v in pairs(features_list) do
  require('zycore.one.' .. v)
end
