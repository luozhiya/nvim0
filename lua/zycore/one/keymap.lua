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

local api = vim.api
local hardworking = require('zycore.base.hardworking')

local nnoremap = hardworking.nnoremap
local inoremap = hardworking.inoremap
local vnoremap = hardworking.vnoremap
local xnoremap = hardworking.xnoremap
local cnoremap = hardworking.cnoremap

-- Remap ',' as leader key
-- set_keymap("", ",", "<Nop>", opts)
vim.g.mapleader = ','
vim.g.maplocalleader = ','

-- 打开 .nvimrc
vim.cmd([[
noremap <leader>o :e! $MYVIMRC<CR>
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

-- Soft wrap 移动列
-- noremap j gj
-- noremap k gk
vim.cmd([[
nnoremap <expr> j v:count ? 'j' : 'gj'
nnoremap <expr> k v:count ? 'k' : 'gk'	
]])

-- 用 j, k 循环补齐列表，不起作用
-- vim.cmd([[
-- inoremap <expr> j ((pumvisible())?("\<C-n>"):("j"))
-- inoremap <expr> k ((pumvisible())?("\<C-p>"):("k"))
-- ]])

-- Insert --
-- Press jk fast to exit insert mode
-- set_keymap("i", "jk", "<ESC>", opts)

-- Move text up and down
inoremap('<A-j>', '<Esc>:m .+1<CR>==gi')
inoremap('<A-k>', '<Esc>:m .-2<CR>==gi')

-- Move text up and down
vnoremap('<A-j>', ':m .+1<CR>==')
vnoremap('<A-k>', ':m .-2<CR>==')
vnoremap('p', '"_dP')

-- Visual Block --
-- Move text up and down
xnoremap('J', ":move '>+1<CR>gv-gv")
xnoremap('K', ":move '<-2<CR>gv-gv")
xnoremap('<A-j>', ":move '>+1<CR>gv-gv")
xnoremap('<A-k>', ":move '<-2<CR>gv-gv")

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

-- Clear search highlight
-- <cmd>nohlsearch<CR>
nnoremap('<esc>', '<esc>:nohlsearch<CR>')

-- New Buffer/Tab
nnoremap('<C-n>', ':ene <CR>')

-- Enter debug model
nnoremap('<F9>', ':BreakpointToggle<CR>')

-- cnoremap('<tab>', '<C-r><C-w>')

-- nnoremap('', ':Lspsaga hover_doc<cr>')
