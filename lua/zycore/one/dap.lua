local dap_ok, dap = pcall(require, 'dap')
if not dap_ok then
  return
end

local fn = vim.fn

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

    -- 💀
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

-- dap.setup({
--   require('which-key').register({
--     d = {
--       name = '+debugger',
--       b = { toggle_breakpoint, 'dap: toggle breakpoint' },
--       B = { set_breakpoint, 'dap: set breakpoint' },
--       c = { continue, 'dap: continue or start debugging' },
--       e = { step_out, 'dap: step out' },
--       i = { step_into, 'dap: step into' },
--       o = { step_over, 'dap: step over' },
--       l = { run_last, 'dap REPL: run last' },
--       t = { repl_toggle, 'dap REPL: toggle' },
--     },
--   }, {
--     prefix = '<leader>',
--   })
-- })

-- local M = {}
-- function M.config()
--   local icons = zycore.base.style.icons
--   fn.sign_define({
--     {
--       name = 'DapBreakpoint',
--       text = icons.misc.bug,
--       texthl = 'DapBreakpoint',
--       linehl = '',
--       numhl = '',
--     },
--     {
--       name = 'DapStopped',
--       text = icons.misc.bookmark,
--       texthl = 'DapStopped',
--       linehl = '',
--       numhl = '',
--     },
--   })

--   dap.configurations.lua = {
--     {
--       type = 'nlua',
--       request = 'attach',
--       name = 'Attach to running Neovim instance',
--       host = function()
--         local value = fn.input('Host [default: 127.0.0.1]: ')
--         return value ~= '' and value or '127.0.0.1'
--       end,
--       port = function()
--         local val = tonumber(fn.input('Port: '))
--         assert(val, 'Please provide a port number')
--         return val
--       end,
--     },
--   }

--   dap.adapters.nlua = function(callback, config)
--     callback({ type = 'server', host = config.host, port = config.port })
--   end
-- end

-- dap.config = M.config
