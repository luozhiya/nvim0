-- mhartington/formatter.nvim
if true then
  -- Utilities for creating configurations
  local util = require('formatter.util')
  -- Provides the Format, FormatWrite, FormatLock, and FormatWriteLock commands
  require('formatter').setup({
    -- Enable or disable logging
    logging = true,
    -- Set the log level
    log_level = vim.log.levels.WARN,
    -- All formatter configurations are opt-in
    filetype = {
      -- Formatter configurations for filetype "lua" go here
      -- and will be executed in order
      lua = {
        -- "formatter.filetypes.lua" defines default configurations for the
        -- "lua" filetype
        require('formatter.filetypes.lua').stylua,

        -- You can also define your own configuration
        function()
          -- Supports conditional formatting
          if util.get_current_buffer_file_name() == 'special.lua' then
            return nil
          end

          -- Full specification of configurations is down below and in Vim help
          -- files
          return {
            exe = 'stylua',
            args = {
              '--search-parent-directories',
              '--stdin-filepath',
              util.escape_path(util.get_current_buffer_file_path()),
              '--',
              '-',
            },
            stdin = true,
          }
        end,
      },

      -- Use the special "*" filetype for defining formatter configurations on
      -- any filetype
      ['*'] = {
        -- "formatter.filetypes.any" defines default configurations for any
        -- filetype
        require('formatter.filetypes.any').remove_trailing_whitespace,
      },
    },
  })
  vim.cmd([[
nnoremap <silent> <leader>X :Format<CR>
nnoremap <silent> <leader>x :FormatWrite<CR>
" augroup FormatAutogroup
"   autocmd!
"   autocmd BufWritePost * FormatWrite
" augroup END
]])
end

-- sbdchd/neoformat
-- vim.cmd([[
-- let g:neoformat_cpp_clangformat = {
--     \ 'exe': '/home/luozhiya/.cache/yay/llvm-git/src/_build/bin/clang-format',
-- \}
-- let g:neoformat_enabled_cpp = ['clangformat']
-- let g:neoformat_enabled_c = ['clangformat']
-- run a formatter on save
-- augroup fmt
--   autocmd!
--   autocmd BufWritePre * undojoin | Neoformat
-- augroup END
-- ]])
if true then
  vim.cmd([[
" Enable alignment
let g:neoformat_basic_format_align = 1

" Enable tab to spaces conversion
let g:neoformat_basic_format_retab = 1

" Enable trimmming of trailing whitespace
let g:neoformat_basic_format_trim = 1
]])
end

-- rhysd/vim-clang-format
if true then
  vim.cmd([[
let g:clang_format#command = '/home/luozhiya/.cache/yay/llvm-git/src/_build/bin/clang-format'
let g:clang_format#detect_style_file = 1
let g:clang_format#auto_format_on_insert_leave = 0
let g:clang_format#auto_format = 0
" map to <Leader>cf in C++ code
autocmd FileType c,cpp,objc nnoremap <buffer><Leader>cf :<C-u>ClangFormat<CR>
autocmd FileType c,cpp,objc vnoremap <buffer><Leader>cf :ClangFormat<CR>
" if you install vim-operator-user
autocmd FileType c,cpp,objc map <buffer><Leader>x <Plug>(operator-clang-format)
" Toggle auto formatting:
" nmap <Leader>C :ClangFormatAutoToggle<CR>
]])
end

-- cappyzawa/trim.nvim
if true then
  require('trim').setup({
    -- if you want to ignore markdown file.
    -- you can specify filetypes.
    disable = { 'markdown' },

    -- if you want to ignore space of top
    patterns = {
      [[%s/\s\+$//e]], -- remove unwanted spaces
      -- [[%s/\($\n\s*\)\+\%$//]],  -- trim last line
      -- [[%s/\%^\n\+//]],          -- trim first line
      -- [[%s/\(\n\n\)\n\+/\1/]],   -- replace multiple blank lines with a single line
    },
  })
end

-- JbzClangFormat
if false then
  -- function! s:JbzClangFormat(first, last)
  --   let l:winview = winsaveview()
  --   execute a:first . "," . a:last . "!/home/luozhiya/.cache/yay/llvm-git/src/_build/bin/clang-format"
  --   call winrestview(l:winview)
  -- endfunction
  -- command! -range=% JbzClangFormat call <sid>JbzClangFormat (<line1>, <line2>)

  -- " Autoformatting with clang-format
  -- au FileType c,cpp nnoremap <buffer><leader>lf :<C-u>JbzClangFormat<CR>
  -- au FileType c,cpp vnoremap <buffer><leader>lf :JbzClangFormat<CR>
end
