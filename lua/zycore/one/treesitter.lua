local ok, configs = pcall(require, 'nvim-treesitter.configs')
if not ok then
  return
end

configs.setup({
  ensure_installed = { 'c', 'cpp', 'cmake', 'lua' }, -- one of "all" or a list of languages
  ignore_install = { 'phpdoc', 'dart' }, -- List of parsers to ignore installing
  highlight = {
    enable = true, -- false will disable the whole extension
    disable = { 'css' }, -- list of language that will be disabled
  },
  autopairs = {
    enable = true,
  },
  indent = { enable = true, disable = { 'python', 'css' } },
  context_commentstring = {
    enable = true,
    enable_autocmd = false,
    config = {
      javascript = {
        __default = '// %s',
        jsx_element = '{/* %s */}',
        jsx_fragment = '{/* %s */}',
        jsx_attribute = '// %s',
        comment = '// %s',
      },
      lua = {
        __default = '-- %s',
        __multiline = '--[[ %s ]]',
      },
    },
  },
})
