local g = vim.g
local hardworking = require('zycore.base.hardworking')

-- https://www.sqlite.org/download.html
-- 64-bit DLL (x64) for SQLite version 3.39.4.
if hardworking.is_windows() then
  g.sqlite_clib_path = 'D:/Omega/App/Neovim/nvim-win64/bin/sqlite3.dll'
end
