local hardworking = require('zycore.base.hardworking')

local nnoremap = hardworking.nnoremap
local inoremap = hardworking.inoremap
local vnoremap = hardworking.vnoremap
local xnoremap = hardworking.xnoremap

nnoremap('<c-p>', [[<cmd>Telescope buffers show_all_buffers=true theme=get_dropdown<cr>]])
nnoremap('<c-P>', [[<cmd>Telescope commands theme=get_dropdown<cr>]])
nnoremap('<c-a>', [[<cmd>Telescope buffers show_all_buffers=true theme=get_dropdown<cr>]])
nnoremap('<c-e>', [[<cmd>Telescope frecency theme=get_dropdown<cr>]])
nnoremap('<c-s>', [[<cmd>Telescope git_files theme=get_dropdown<cr>]])
nnoremap('<c-d>', [[<cmd>Telescope find_files theme=get_dropdown<cr>]])
-- nnoremap('<c-g>', [[<cmd>Telescope live_grep theme=get_dropdown<cr>]])
nnoremap('<c-g>', [[<cmd>lua require("telescope").extensions.live_grep_args.live_grep_args() theme=get_dropdown<cr>]])
