local bufferline_ok, bufferline = pcall(require, "bufferline")
if not bufferline_ok then
  return
end

-- local zycore_base_ok, _ = pcall(require, "base.style")
-- if not zycore_base_ok then
--   print (zycore.base.style.palette.vim_blue)
--   return
-- end

-- print (zycore.base.style.palette.vim_blue)

bufferline.setup {
  options = {
    mode = "buffer",
    numbers = "none",
    diagnostics = "nvim_lsp",
    always_show_bufferline = true,
    close_command = "Bdelete! %d",       -- can be a string | function, see "Mouse actions"
    right_mouse_command = "Bdelete! %d", -- can be a string | function, see "Mouse actions"
    left_mouse_command = "buffer %d",    -- can be a string | function, see "Mouse actions"
    middle_mouse_command = nil,          -- can be a string | function, see "Mouse actions" 
    -- indicator = {
    --     icon = '▎', -- this should be omitted if indicator style is not 'icon'
    --     style = 'icon',
    -- },       
    offsets = {
      {
        filetype = "NvimTree",
        text = "File Explorer",
        highlight = "Directory",
        separator = true,
        text_align = "left"
      }
    },
    -- hover = {
    --     enabled = true,
    --     delay = 200,
    --     reveal = {'close'}
    -- },    
    color_icons = false,
    separator_style = "thin",
    enforce_regular_tabs = true,
    buffer_close_icon = '',
    modified_icon = '●',
    close_icon = '',
    left_trunc_marker = '',
    right_trunc_marker = '',
    show_buffer_icons = false,
    show_buffer_close_icons = false,
    show_close_icon = false,    
    show_tab_indicators = true,
    show_buffer_default_icon = false,
  },  
  highlights = {
    buffer_selected = {
        fg = '#569cd6',
        bg = normal_bg,
        bold = false,
        italic = false,
    },
  },
}
