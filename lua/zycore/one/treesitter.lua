local treesitter_ok, treesitter = pcall(require, 'nvim-treesitter.configs')
if not treesitter_ok then
  return
end

local hardworking = require('zycore.base.hardworking')
local ensure_installed
if hardworking.is_windows() then
  ensure_installed = { 'c', 'cpp', 'cmake', 'lua', 'markdown', 'fennel', 'clojure' }
else
  ensure_installed = 'all'
end

local opts = {
  ensure_installed = ensure_installed, -- one of "all" or a list of languages
  ignore_install = { 'phpdoc', 'dart' }, -- List of parsers to ignore installing
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
  highlight = {
    -- `false` will disable the whole extension
    enable = true,

    -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
    -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
    -- the name of the parser)
    -- list of language that will be disabled
    -- disable = { 'css' }, -- list of language that will be disabled
    -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
    disable = function(lang, buf)
      local max_filesize = 100 * 1024 -- 100 KB
      local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
      if ok and stats and stats.size > max_filesize then
        return true
      end
    end,

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}

treesitter.setup(opts)
