local bufferline_ok, bufferline = pcall(require, 'bufferline')
if not bufferline_ok then
  return
end

local style_constexpr = require('zycore.base.style_constexpr')

local vs_selected_fg = style_constexpr.palette.white
local vs_selected_bg = style_constexpr.palette.vs_blue

bufferline.setup({
  options = {
    mode = 'buffer',
    numbers = 'none',
    diagnostics = 'nvim_lsp',
    always_show_bufferline = true,
    close_command = 'Bdelete! %d', -- can be a string | function, see "Mouse actions"
    right_mouse_command = 'Bdelete! %d', -- can be a string | function, see "Mouse actions"
    left_mouse_command = 'buffer %d', -- can be a string | function, see "Mouse actions"
    middle_mouse_command = nil, -- can be a string | function, see "Mouse actions"
    -- indicator = {
    --     icon = '▎', -- this should be omitted if indicator style is not 'icon'
    --     style = 'icon',
    -- },
    offsets = {
      {
        filetype = 'NvimTree',
        text = 'File Explorer',
        highlight = 'Directory',
        separator = true,
        text_align = 'left',
        -- padding = 10,
      },
    },
    hover = {
      enabled = true,
      delay = 200,
      reveal = { 'close' },
    },
    max_name_length = 25,
    truncate_names = false, -- whether or not tab names should be truncated
    tab_size = 25,
    max_prefix_length = 15, -- prefix used when a buffer is de-duplicated
    color_icons = false,
    separator_style = 'thin',
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
    fill = {
      fg = normal_fg,
      bg = normal_bg,
    },
    background = {
      fg = normal_fg,
      bg = normal_bg,
    },
    tab = {
      fg = normal_fg,
      bg = normal_bg,
    },
    tab_selected = {
      fg = vs_selected_fg,
      bg = vs_selected_bg,
    },
    tab_close = {
      fg = normal_fg,
      bg = normal_bg,
    },
    close_button = {
      fg = normal_fg,
      bg = normal_bg,
    },
    close_button_visible = {
      fg = normal_fg,
      bg = normal_bg,
    },
    close_button_selected = {
      fg = vs_selected_fg,
      bg = vs_selected_bg,
    },
    buffer_visible = {
      fg = normal_fg,
      bg = normal_bg,
    },
    buffer_selected = {
      fg = vs_selected_fg,
      bg = vs_selected_bg,
      bold = false,
      italic = false,
    },
    numbers = {
      fg = normal_fg,
      bg = normal_bg,
    },
    numbers_visible = {
      fg = normal_fg,
      bg = normal_bg,
    },
    numbers_selected = {
      fg = vs_selected_fg,
      bg = vs_selected_bg,
      bold = false,
      italic = false,
    },
    diagnostic = {
      fg = normal_fg,
      bg = normal_bg,
    },
    diagnostic_visible = {
      fg = normal_fg,
      bg = normal_bg,
    },
    diagnostic_selected = {
      fg = vs_selected_fg,
      bg = vs_selected_bg,
      bold = false,
      italic = false,
    },
    hint = {
      fg = normal_fg,
      sp = normal_sp,
      bg = normal_bg,
    },
    hint_visible = {
      fg = normal_fg,
      bg = normal_bg,
    },
    hint_selected = {
      fg = vs_selected_fg,
      bg = vs_selected_bg,
      sp = normal_sp,
      bold = false,
      italic = false,
    },
    hint_diagnostic = {
      fg = normal_fg,
      sp = normal_sp,
      bg = normal_bg,
    },
    hint_diagnostic_visible = {
      fg = normal_fg,
      bg = normal_bg,
    },
    hint_diagnostic_selected = {
      fg = vs_selected_fg,
      bg = vs_selected_bg,
      sp = normal_sp,
      bold = false,
      italic = false,
    },
    info = {
      fg = normal_fg,
      sp = normal_sp,
      bg = normal_bg,
    },
    info_visible = {
      fg = normal_fg,
      bg = normal_bg,
    },
    info_selected = {
      fg = vs_selected_fg,
      bg = vs_selected_bg,
      sp = normal_sp,
      bold = false,
      italic = false,
    },
    info_diagnostic = {
      fg = normal_fg,
      sp = normal_sp,
      bg = normal_bg,
    },
    info_diagnostic_visible = {
      fg = normal_fg,
      bg = normal_bg,
    },
    info_diagnostic_selected = {
      fg = vs_selected_fg,
      bg = vs_selected_bg,
      sp = normal_sp,
      bold = false,
      italic = false,
    },
    warning = {
      fg = normal_fg,
      sp = normal_sp,
      bg = normal_bg,
    },
    warning_visible = {
      fg = normal_fg,
      bg = normal_bg,
    },
    warning_selected = {
      fg = vs_selected_fg,
      bg = vs_selected_bg,
      sp = normal_sp,
      bold = false,
      italic = false,
    },
    warning_diagnostic = {
      fg = normal_fg,
      sp = normal_sp,
      bg = normal_bg,
    },
    warning_diagnostic_visible = {
      fg = normal_fg,
      bg = normal_bg,
    },
    warning_diagnostic_selected = {
      fg = vs_selected_fg,
      bg = vs_selected_bg,
      sp = warning_diagnostic_fg,
      bold = false,
      italic = false,
    },
    error = {
      fg = normal_fg,
      bg = normal_bg,
      sp = normal_sp,
    },
    error_visible = {
      fg = normal_fg,
      bg = normal_bg,
    },
    error_selected = {
      fg = vs_selected_fg,
      bg = vs_selected_bg,
      sp = normal_sp,
      bold = false,
      italic = false,
    },
    error_diagnostic = {
      fg = normal_fg,
      bg = normal_bg,
      sp = normal_sp,
    },
    error_diagnostic_visible = {
      fg = normal_fg,
      bg = normal_bg,
    },
    error_diagnostic_selected = {
      fg = vs_selected_fg,
      bg = vs_selected_bg,
      sp = normal_sp,
      bold = false,
      italic = false,
    },
    modified = {
      fg = normal_fg,
      bg = normal_bg,
    },
    modified_visible = {
      fg = normal_fg,
      bg = normal_bg,
    },
    modified_selected = {
      fg = vs_selected_fg,
      bg = vs_selected_bg,
    },
    duplicate_selected = {
      fg = vs_selected_fg,
      bg = vs_selected_bg,
      italic = false,
    },
    duplicate_visible = {
      fg = normal_fg,
      bg = normal_bg,
      italic = true,
    },
    duplicate = {
      fg = normal_fg,
      bg = normal_bg,
      italic = true,
    },
    separator_selected = {
      fg = vs_selected_fg,
      bg = vs_selected_bg,
    },
    separator_visible = {
      fg = normal_fg,
      bg = normal_bg,
    },
    separator = {
      fg = normal_fg,
      bg = normal_bg,
    },
    indicator_selected = {
      fg = vs_selected_fg,
      bg = vs_selected_bg,
    },
    pick_selected = {
      fg = vs_selected_fg,
      bg = vs_selected_bg,
      bold = false,
      italic = false,
    },
    pick_visible = {
      fg = normal_fg,
      bg = normal_bg,
      bold = false,
      italic = false,
    },
    pick = {
      fg = normal_fg,
      bg = normal_bg,
      bold = false,
      italic = false,
    },
    offset_separator = {
      fg = normal_bg,
      bg = normal_bg,
    },
  },
})
