-- Target:
-- https://github.com/nvim-lualine/lualine.nvim
-- Template:
-- https://github.com/nvim-telescope/telescope.nvim/issues/new?assignees=&labels=bug&template=bug_report.yml
-- Run:
-- nvim -nu ./debug/lualine.lua

vim.cmd([[set runtimepath=$VIMRUNTIME]])
vim.cmd([[set packpath=/tmp/nvim/site]])
local package_root = '/tmp/nvim/site/pack'
local install_path = package_root .. '/packer/start/packer.nvim'
local function load_plugins()
  require('packer').startup({
    {
      'wbthomason/packer.nvim',
      'nvim-lualine/lualine.nvim',
    },
    config = {
      package_root = package_root,
      compile_path = install_path .. '/plugin/packer_compiled.lua',
      display = { non_interactive = true },
    },
  })
end

_G.load_config = function()
  local ratio_progress = function()
    local current_line = vim.fn.line('.')
    local total_lines = vim.fn.line('$')
    local line_ratio = current_line / total_lines * 100
    return string.format('%02d%%', line_ratio)
  end
  local opts = {
    sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = {},
      lualine_x = {},
      lualine_y = {},
      lualine_z = { ratio_progress },
    },
  }
  require('lualine').setup(opts)
end

if vim.fn.isdirectory(install_path) == 0 then
  vim.fn.system({ 'git', 'clone', '--depth=1', 'https://github.com/wbthomason/packer.nvim', install_path })
end
load_plugins()
require('packer').sync()
vim.cmd([[autocmd User PackerComplete ++once echo "Ready!" | lua load_config()]])
