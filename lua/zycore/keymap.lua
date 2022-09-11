-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",
-- Key
--   <M-> = Alt
--   <C-> = Ctrl

local opts = { noremap = true, silent = true }
local term_opts = { silent = true }

-- Shorten function name
local keymap = vim.api.nvim_set_keymap
local nnoremap = function(lhs, rhs)
    vim.api.nvim_set_keymap('n', lhs, rhs, opts)
end
local vnoremap = function(lhs, rhs)
    vim.api.nvim_set_keymap('v', lhs, rhs, opts)
end

-- Remap ',' as leader key
-- keymap("", ",", "<Nop>", opts)
vim.g.mapleader = ","
vim.g.maplocalleader = ","

-- 打开 .nvimrc
vim.cmd([[
noremap <leader>e :e! $MYVIMRC<CR>
]])

-- Normal
-- Better window navigation, Alt+[hjkl]
nnoremap("<M-h>", "<C-w>h")
nnoremap("<M-j>", "<C-w>j")
nnoremap("<M-k>", "<C-w>k")
nnoremap("<M-l>", "<C-w>l")

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
nnoremap("<C-j>", "15gj")
nnoremap("<C-k>", "15gk")

-- 用 j, k 循环补齐列表，不起作用
-- vim.cmd([[
-- inoremap <expr> j ((pumvisible())?("\<C-n>"):("j"))
-- inoremap <expr> k ((pumvisible())?("\<C-p>"):("k"))
-- ]])

-- Insert --
-- Press jk fast to exit insert mode 
-- keymap("i", "jk", "<ESC>", opts)

-- Move text up and down
keymap("i", "<A-j>", "<Esc>:m .+1<CR>==gi", opts)
keymap("i", "<A-k>", "<Esc>:m .-2<CR>==gi", opts)

-- Move text up and down
keymap("v", "<A-j>", ":m .+1<CR>==", opts)
keymap("v", "<A-k>", ":m .-2<CR>==", opts)
keymap("v", "p", '"_dP', opts)

-- Visual Block --
-- Move text up and down
keymap("x", "J", ":move '>+1<CR>gv-gv", opts)
keymap("x", "K", ":move '<-2<CR>gv-gv", opts)
keymap("x", "<A-j>", ":move '>+1<CR>gv-gv", opts)
keymap("x", "<A-k>", ":move '<-2<CR>gv-gv", opts)

-- Navigate buffers
keymap("n", "<S-l>", ":bnext<CR>", opts)
keymap("n", "<S-h>", ":bprevious<CR>", opts)
keymap("n", "<tab>", ":bnext<CR>", opts)
keymap("n", "<C-w>", ":Bdelete<CR>", opts)

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
keymap("n", "<C-A-x>", ":ToggleTerm size=10 direction=horizontal<CR>", opts)
keymap("n", "<C-A-v>", ":ToggleTerm size=40 direction=vertical<CR>", opts)
-- vim.cmd([[
-- noremap <C-A-t> :ToggleTerm size=12 direction=horizontal<CR>
-- ]])
