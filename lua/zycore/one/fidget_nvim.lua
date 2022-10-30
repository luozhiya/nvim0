local opts = {
  text = {
    spinner = 'moon',
    done = '', --  v
    commenced = 'Started',
    completed = 'Completed',
  },
  align = {
    bottom = true,
    right = true,
  },
  window = {
    relative = 'win',
    blend = 100,
    zindex = nil,
    border = 'none',
  },
  timer = {
    spinner_rate = 125,
    fidget_decay = 2000,
    task_decay = 1000,
  },
  fmt = {
    leftpad = true,
    stack_upwards = true,
    max_width = 0,
    fidget = function(fidget_name, spinner)
      return string.format('%s %s', spinner, fidget_name)
    end,
    task = function(task_name, message, percentage)
      return string.format('%s%s [%s]', message, percentage and string.format(' (%.0f%%)', percentage) or '', task_name)
    end,
  },
  sources = {
    ['null-ls'] = { ignore = true },
  },
  debug = {
    logging = false,
    strict = false,
  },
}

require('fidget').setup(opts)
