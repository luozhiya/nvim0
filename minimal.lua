vim.cmd [[set runtimepath=$VIMRUNTIME]]
vim.cmd [[set packpath=/tmp/nvim/site]]
local package_root = '/tmp/nvim/site/pack'
local install_path = package_root .. '/packer/start/packer.nvim'
local function load_plugins()
  require('packer').startup {
    {
      'wbthomason/packer.nvim',
      {
        'nvim-telescope/telescope.nvim',
        requires = {
          'nvim-lua/plenary.nvim',
          { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' },
        },
      },
      -- ADD PLUGINS THAT ARE _NECESSARY_ FOR REPRODUCING THE ISSUE
    },
    config = {
      package_root = package_root,
      compile_path = install_path .. '/plugin/packer_compiled.lua',
      display = { non_interactive = true },
    },
  }
end
_G.load_config = function()
  require('telescope').setup({
  defaults = {
    prompt_prefix = '? ',
    selection_caret = '? ',
    path_display = { 'truncate = 3' },

    file_ignore_patterns = {
      "node_modules",
      ".work/.*",
      ".cache/.*",
      ".idea/.*",
      "dist/.*",
      ".git/.*"
    },
  },  
  pickers = {
    find_files = {
      find_command = { 'fd', "--no-ignore",  '--type=file', '--hidden', '--exclude=.git/' },
    },
  },
  })
  --require('telescope').load_extension('fzf')
  -- ADD INIT.LUA SETTINGS THAT ARE _NECESSARY_ FOR REPRODUCING THE ISSUE
end
if vim.fn.isdirectory(install_path) == 0 then
  print("Installing Telescope and dependencies.")
  vim.fn.system { 'git', 'clone', '--depth=1', 'https://github.com/wbthomason/packer.nvim', install_path }
end
load_plugins()
require('packer').sync()
vim.cmd [[autocmd User PackerComplete ++once echo "Ready!" | lua load_config()]]

vim.opt.termguicolors = true
