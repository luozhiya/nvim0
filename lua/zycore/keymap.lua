-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",
-- Key
--   <M-> = Alt
--   <A-> = Alt
--   <C-> = Ctrl
--   <S-> = Shift

local opts = { noremap = true, silent = true }
local term_opts = { silent = true }

-- Shorten function name
local set_keymap = vim.api.nvim_set_keymap
local nnoremap = function(lhs, rhs)
  vim.api.nvim_set_keymap('n', lhs, rhs, opts)
end
local vnoremap = function(lhs, rhs)
  vim.api.nvim_set_keymap('v', lhs, rhs, opts)
end

-- Remap ',' as leader key
-- set_keymap("", ",", "<Nop>", opts)
vim.g.mapleader = ','
vim.g.maplocalleader = ','

-- 打开 .nvimrc
vim.cmd([[
noremap <leader>e :e! $MYVIMRC<CR>
]])

-- Normal
-- Better window navigation, Alt+[hjkl]
nnoremap('<M-h>', '<C-w>h')
nnoremap('<M-j>', '<C-w>j')
nnoremap('<M-k>', '<C-w>k')
nnoremap('<M-l>', '<C-w>l')

-- 用 ; 代替 : 不用去按 Shift 了。受这个的影响就不要用简单的 map : 了
vim.cmd([[
nnoremap ; :
nnoremap : ;
vnoremap ; :
vnoremap : ;
]])
-- lua 版本的不知道为什么不起作用
-- nnoremap(";", ":")
-- nnoremap(":", ";")
-- vnoremap(";", ":")
-- vnoremap(":", ";")

-- ctrl-j, ctrl-k 每次跳转15行
nnoremap('<C-j>', '15gj')
nnoremap('<C-k>', '15gk')

-- 用 j, k 循环补齐列表，不起作用
-- vim.cmd([[
-- inoremap <expr> j ((pumvisible())?("\<C-n>"):("j"))
-- inoremap <expr> k ((pumvisible())?("\<C-p>"):("k"))
-- ]])

-- Insert --
-- Press jk fast to exit insert mode
-- set_keymap("i", "jk", "<ESC>", opts)

-- Move text up and down
set_keymap('i', '<A-j>', '<Esc>:m .+1<CR>==gi', opts)
set_keymap('i', '<A-k>', '<Esc>:m .-2<CR>==gi', opts)

-- Move text up and down
set_keymap('v', '<A-j>', ':m .+1<CR>==', opts)
set_keymap('v', '<A-k>', ':m .-2<CR>==', opts)
set_keymap('v', 'p', '"_dP', opts)

-- Visual Block --
-- Move text up and down
set_keymap('x', 'J', ":move '>+1<CR>gv-gv", opts)
set_keymap('x', 'K', ":move '<-2<CR>gv-gv", opts)
set_keymap('x', '<A-j>', ":move '>+1<CR>gv-gv", opts)
set_keymap('x', '<A-k>', ":move '<-2<CR>gv-gv", opts)

-- Navigate buffers
set_keymap('n', '<S-l>', ':bnext<CR>', opts)
set_keymap('n', '<S-h>', ':bprevious<CR>', opts)
set_keymap('n', '<tab>', ':bnext<CR>', opts)
set_keymap('n', '<C-w>', ':Bdelete<CR>', opts)
set_keymap('n', '<A-w>', ':Bdelete!<CR>', opts)

-- To use `ALT+{h,j,k,l}` to navigate windows from any mode:
vim.cmd([[
tnoremap <A-h> <C-\><C-N><C-w>h
tnoremap <A-j> <C-\><C-N><C-w>j
tnoremap <A-k> <C-\><C-N><C-w>k
tnoremap <A-l> <C-\><C-N><C-w>l
" inoremap <A-h> <C-\><C-N><C-w>h
" inoremap <A-j> <C-\><C-N><C-w>j
" inoremap <A-k> <C-\><C-N><C-w>k
" inoremap <A-l> <C-\><C-N><C-w>l
nnoremap <A-h> <C-w>h
nnoremap <A-j> <C-w>j
nnoremap <A-k> <C-w>k
nnoremap <A-l> <C-w>l
]])

-- CTRL + ALT + x open terminal
set_keymap('n', '<C-A-x>', ':ToggleTerm size=10 direction=horizontal<CR>', opts)
set_keymap('n', '<C-A-v>', ':ToggleTerm size=40 direction=vertical<CR>', opts)
-- vim.cmd([[
-- noremap <C-A-t> :ToggleTerm size=12 direction=horizontal<CR>
-- ]])

-- Debug
set_keymap('n', '<S-F9>', ':lua _CONTINUE()<cr>', opts)
set_keymap('n', '<C-F2>', ':DapTeminate<cr>', opts)
set_keymap('n', '<C-F8>', ':lua _TOGGLE_BREAKPOINT()<cr>', opts)
set_keymap('n', '<F8>', ':lua _STEP_OVER()<cr>', opts)
set_keymap('n', '<F7>', ':lua _STEP_INTO()<cr>', opts)
set_keymap('n', '<S-F8>', ':lua _STEP_OUT()<cr>', opts)
