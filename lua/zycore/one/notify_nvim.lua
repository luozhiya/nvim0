local notify = require('notify')

local BUILTIN_RENDERERS = {
  DEFAULT = 'default',
  MINIMAL = 'minimal',
}

local BUILTIN_STAGES = {
  FADE = 'fade',
  SLIDE = 'slide',
  FADE_IN_SLIDE_OUT = 'fade_in_slide_out',
  STATIC = 'static',
}

local opts = {
  level = vim.log.levels.INFO,
  timeout = 800,
  max_width = nil,
  max_height = nil,
  stages = BUILTIN_STAGES.FADE_IN_SLIDE_OUT,
  render = BUILTIN_RENDERERS.MINIMAL,
  background_colour = 'Normal',
  on_open = nil,
  on_close = nil,
  minimum_width = 50,
  fps = 60,
  top_down = true,
  icons = {
    ERROR = '',
    WARN = '',
    INFO = '',
    DEBUG = '',
    TRACE = '✎',
  },
}

notify.setup(opts)

vim.notify = notify
