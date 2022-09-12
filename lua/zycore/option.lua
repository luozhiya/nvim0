local option = {
  -- View
  laststatus = 2, -- 始终显示状态栏
  cmdheight = 1, -- command-line 的行数
  showmode = true, -- 当前 NVIM 的模式
  showcmd = true, -- 在非 : 模式下输入的 command 会显示在状态栏

  title = true,
  cursorline = true,
  scrolloff = 8, -- cursor 接近 buffer 顶部和底部时会尽量保持 3 行的距离
  sidescrolloff = 8,
  number = true, -- set numberd liens
  ruler = true, -- show row/col in status line
  relativenumber = true, -- set relative numbered lines
  signcolumn = 'auto:2-5', -- always show the sign column, otherwise it would shift the text each time
  termguicolors = true, -- bufferline: You are *strongly* advised to use `termguicolors` for this plugin

  showmatch = true, -- 输入代码时高亮显示匹配的括号
  matchtime = 5, -- 匹配括号时高亮的时间。500ms

  wrap = false, -- display lines as one long line

  -- Indent
  -- autoindent = true, -- neovim default true
  tabstop = 4, -- 一个 tab 等于多少 space
  expandtab = true, -- tab 转换成 space, 不出现制表字符
  smarttab = true, -- 根据文件整体情况来决定 tab 是几个 space

  shiftwidth = 4, -- 一级 indent 是多少 space
  softtabstop = 4, -- 按一次 del 或者 backspace 时，应该删除多少个 space
  shiftround = true, -- 自动 indent 应该是 shiftwidth 的整数倍
  smartindent = true,

  cinoptions = vim.opt.cinoptions:append('g0'), -- C++ public等不额外产生indent

  -- Find
  ignorecase = true, -- 一般情况大小写不敏感搜索
  smartcase = true, -- 如果搜索时使用了大写，则自动对大小写敏感
  hlsearch = true, -- highlight all matches on previous search pattern
  incsearch = true, -- 键入时高亮
  gdefault = true, -- search/replace global

  -- Encode
  encoding = 'utf-8', -- Unicode 和中文支持,  set enc
  fileencoding = 'utf-8', -- the encoding written to a file
  fileencodings = { 'utf-8', 'ucs-bom', 'gb18030', 'gbk', 'gb2312', 'cp936' }, -- set fencs

  fileformat = 'unix', -- 默认的文件行末尾格式 unix
  fileformats = { 'unix', 'dos', 'mac' }, -- 依次检测文件格式： unix, dos, mac

  -- Font
  -- guifont = "monospace:h17"    -- the font used in graphical neovim application

  -- Timings
  updatetime = 300, -- faster completion (4000ms default)
  timeout = true,
  timeoutlen = 500,
  ttimeoutlen = 10,

  -- Completion
  pumheight = 10, -- pop up menu height
  -- wildmenu = true,               -- 开启 command 补齐
  -- wildmode = {"list:longest", "full"},         -- 列出所有最长子串的补齐，和其他完整的匹配
  -- completeopt = {"menu", "menuone", "longest"},   --关闭 preview 窗口
  completeopt = { 'menu', 'menuone', 'noselect' },

  -- Advance
  clipboard = 'unnamedplus', -- allows neovim to access the system clipboard
  backup = false, -- creates a backup file
  swapfile = false, -- creates a swapfile
  mouse = 'a', -- allows the mouse to be used in neovim
  undofile = false, -- enable persistent undo
  undolevels = 100, -- 很多的 undo
  history = 100, -- 搜索和 command 的历史
  hidden = true, -- 即使 buffer 被改变还没保存，也允许其隐藏
  autoread = true, -- 自动加载在外部被改变的文件
  whichwrap = vim.opt.whichwrap:append('<,>,[,],h,l'), -- 让 backspace， cursor 移动时可以跨行
  mousemoveevent = true,
  -- shortmess = 'actI', -- 减少启动时画面显示的东西
  -- Message output on vim actions
  shortmess = {
    t = true, -- truncate file messages at start
    A = true, -- ignore annoying swap file messages
    o = true, -- file-read message overwrites previous
    O = true, -- file-read message overwrites previous
    T = true, -- truncate non-file messages in middle
    f = true, -- (file x of x) instead of just (x of x
    F = true, -- Don't give file info when editing a file, NOTE: this breaks autocommand messages
    s = true,
    c = true,
    W = true, -- Don't show [w] or written when writing
  },
}

for k, v in pairs(option) do
  vim.opt[k] = v
end

vim.cmd([[
autocmd FileType lua setlocal tabstop=2
]])

-- vim.cmd "set whichwrap+=<,>,[,],h,l"
return option
