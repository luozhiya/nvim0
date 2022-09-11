local bufferline_ok, bufferline = pcall(require, "bufferline")
if not bufferline_ok then
  return
end

bufferline.setup {
  options = {
    mode = "buffer",
    numbers = "both",
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
    color_icons = true,
    separator_style = "slant",
    enforce_regular_tabs = true,
    buffer_close_icon = '',
    modified_icon = '●',
    close_icon = '',
    left_trunc_marker = '',
    right_trunc_marker = '',
    show_buffer_icons = true,
    show_buffer_close_icons = true,
    show_close_icon = true,    
    show_tab_indicators = true,
  },  
}
