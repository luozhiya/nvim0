local hardworking = require('zycore.base.hardworking')
local nnoremap = hardworking.nnoremap

-- Navigate buffers
nnoremap('<S-l>', ':bnext<CR>')
nnoremap('<S-h>', ':bprevious<CR>')
nnoremap('<tab>', ':bnext<CR>')
nnoremap('<S-tab>', ':bprevious<CR>')
nnoremap('<C-w>', ':Bdelete<CR>')
nnoremap('<A-w>', ':Bdelete!<CR>')
