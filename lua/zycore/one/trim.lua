local ok, trim = pcall(require, 'trim')
if not ok then
  return
end

local opts = {
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
}

-- cappyzawa/trim.nvim
-- trim.setup()
