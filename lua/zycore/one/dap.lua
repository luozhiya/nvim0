local dap = require('dap')

local fn = vim.fn
local style_constexpr = require('zycore.base.style_constexpr')
local hardworking = require('zycore.base.hardworking')
local nnoremap = hardworking.nnoremap

function _REPL_TOGGLE()
  dap.repl.toggle(nil, 'botright split')
end

function _CONTINUE()
  dap.continue()
end

function _STEP_OUT()
  dap.step_out()
end

function _STEP_INTO()
  dap.step_into()
end

function _STEP_OVER()
  dap.step_over()
end

function _RUN_LAST()
  dap.run_last()
end

function _TOGGLE_BREAKPOINT()
  dap.toggle_breakpoint()
end

function _SET_BREAKPOINT()
  dap.set_breakpoint(fn.input('Breakpoint condition: '))
end

dap.adapters.lldb = {
  type = 'executable',
  command = 'lldb-vscode',
  name = 'lldb',
}

dap.configurations.cpp = {
  {
    name = 'Launch',
    type = 'lldb',
    request = 'launch',
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
    args = {},

    -- if you change `runInTerminal` to true, you might need to change the yama/ptrace_scope setting:
    --
    --    echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
    --
    -- Otherwise you might get the following error:
    --
    --    Error on launch: Failed to attach to the target process
    --
    -- But you should be aware of the implications:
    -- https://www.kernel.org/doc/html/latest/admin-guide/LSM/Yama.html
    -- runInTerminal = false,
  },
}

-- If you want to use this for Rust and C, add something like this:

dap.configurations.c = dap.configurations.cpp
dap.configurations.rust = dap.configurations.cpp

--[[ dap.setup({ ]]
--[[   require('which-key').register({ ]]
--[[     d = { ]]
--[[       name = '+debugger', ]]
--[[       b = { dap.toggle_breakpoint, 'dap: toggle breakpoint' }, ]]
--[[       B = { dap.set_breakpoint, 'dap: set breakpoint' }, ]]
--[[       c = { dap.continue, 'dap: continue or start debugging' }, ]]
--[[       e = { dap.step_out, 'dap: step out' }, ]]
--[[       i = { dap.step_into, 'dap: step into' }, ]]
--[[       o = { dap.step_over, 'dap: step over' }, ]]
--[[       l = { dap.run_last, 'dap REPL: run last' }, ]]
--[[       t = { dap.repl_toggle, 'dap REPL: toggle' }, ]]
--[[     }, ]]
--[[   }, { ]]
--[[     prefix = '<leader>', ]]
--[[   }) ]]
--[[ }) ]]

local M = {}
function M.config()
  local icons = style_constexpr.icons
  fn.sign_define({
    {
      name = 'DapBreakpoint',
      text = icons.misc.circle,
      texthl = 'DapBreakpoint',
      linehl = '',
      numhl = '',
    },
    {
      name = 'DapStopped',
      text = icons.misc.debug_right,
      texthl = 'DapStopped',
      linehl = '',
      numhl = '',
    },
  })

  dap.configurations.lua = {
    {
      type = 'nlua',
      request = 'attach',
      name = 'Attach to running Neovim instance',
      -- host = function()
      --   local value = fn.input('Host [default: 127.0.0.1]: ')
      --   return value ~= '' and value or '127.0.0.1'
      -- end,
      -- port = function()
      --   local val = tonumber(fn.input('Port: '))
      --   assert(val, 'Please provide a port number')
      --   return val
      -- end,
    },
  }

  dap.adapters.nlua = function(callback, config)
    callback({ type = 'server', host = config.host or '127.0.0.1', port = config.port or 8086 })
    -- callback({ type = 'server', host = config.host, port = config.port })
  end
end

dap.config = M.config
dap.config()

-- Debug
-- nnoremap('<S-F5>', ':lua require"osv".launch({port = 8086})<CR>')
-- nnoremap('<F5>', ':lua _CONTINUE()<cr>')
-- nnoremap('<F6>', ':DapTeminate<cr>')
-- nnoremap('<F9>', ':lua _TOGGLE_BREAKPOINT()<cr>')
-- nnoremap('<F10>', ':lua _STEP_OVER()<cr>')
-- nnoremap('<F11>', ':lua _STEP_INTO()<cr>')
-- nnoremap('<F8>', ':lua _STEP_OUT()<cr>')

local map = vim.api.nvim_set_keymap
local create_cmd = vim.api.nvim_create_user_command

-- create_cmd('BreakpointToggle', function()
--   require('persistent-breakpoints.api').toggle_breakpoint()
-- end, {})
-- create_cmd('BreakpointToggle', function()
--   require('dap').toggle_breakpoint()
-- end, {})
-- create_cmd('Debug', function()
--   require('dap').continue()
-- end, {})
-- create_cmd('DapREPL', function()
--   require('dap').repl.open()
-- end, {})

-- map('n', '<F5>', '', {
--   callback = function()
--     require('dap').continue()
--   end,
--   noremap = true,
-- })
-- shift
-- working in neovide
-- nnoremap('<S-F5>', ':DapTerminate<cr>')

-- map('n', '<F10>', '', {
--   callback = function()
--     require('dap').step_over()
--   end,
--   noremap = true,
-- })
-- map('n', '<F11>', '', {
--   callback = function()
--     require('dap').step_into()
--   end,
--   noremap = true,
-- })
-- map('n', '<F12>', '', {
--   callback = function()
--     require('dap').step_out()
--   end,
--   noremap = true,
-- })
