local M = {}

local NONAME = '[No Name]'

-- stylua: ignore start
-- return jit.os:find('Linux') -- Windows
function M.is_windows()       return vim.loop.os_uname().sysname == 'Windows_NT'                                end
function M.is_kernel()        return vim.loop.os_uname().sysname == 'Linux'                                     end
function M.nt_sep()           return '\\'                                                                       end
function M.kernel_sep()       return '/'                                                                        end
function M.os_sep()           return package.config:sub(1, 1)                                                   end
function M.to_nt(s)           return s:gsub(M.kernel_sep(), M.nt_sep())                                         end
function M.to_kernel(s)       return s:gsub(M.nt_sep(), M.kernel_sep())                                         end
function M.to_native(s)       return M.is_windows() and M.to_nt(s) or M.to_kernel(s)                            end
function M.shellslash_safe(s) return M.nvim_sep() == M.kernel_sep() and s:gsub(M.nt_sep(), M.kernel_sep()) or s end
function M.is_uri(path)       return path:match('^%w+://') ~= nil                                               end
function M.file_exists(file)  return vim.loop.fs_stat(file) ~= nil                                              end
function M.home()             return vim.loop.os_homedir()                                                      end
function M.concat_paths(...)  return table.concat({ ... }, M.nvim_sep())                                        end
function M.safe_nt(path)      return path:gsub(' ', '\\ ')                                                      end
-- stylua: ignore end

M.root = function()
  return M.is_windows() and M.shellslash_safe(string.sub(vim.loop.cwd(), 1, 1) .. ':' .. M.nt_sep()) or M.kernel_sep()
end
M.nvim_sep = function()
  if M.is_kernel() or (M.is_windows() and vim.opt.shellslash._value == true) then
    return M.kernel_sep()
  end
  return M.nt_sep()
end
M.open = function(uri)
  if uri == nil then
    return vim.notify('Open nil URI', vim.log.levels.INFO)
  end
  local cmd
  if M.is_windows() then
    cmd = { 'explorer', uri }
    cmd = M.to_nt(table.concat(cmd, ' '))
  else
    if vim.fn.executable('xdg-open') == 1 then
      cmd = { 'xdg-open', uri }
    end
  end
  local ret = vim.fn.jobstart(cmd, { detach = true })
  if ret <= 0 then
    local msg = {
      'Failed to open uri',
      ret,
      vim.inspect(cmd),
    }
    vim.notify(table.concat(msg, '\n'), vim.log.levels.ERROR)
  end
end
M.terminal_open = function(dir)
  if dir == nil then
    return vim.notify('Open terminal at nil', vim.log.levels.INFO)
  end
  local cmd
  if M.is_windows() then
    cmd = { 'cmd', dir }
    cmd = M.to_nt(table.concat(cmd, ' '))
  else
    local alacritty = 'alacritty'
    local xfce4 = 'xfce4-terminal'
    if vim.fn.executable(alacritty) == 1 then
      cmd = { alacritty, '--working-directory ' .. dir }
      cmd = table.concat(cmd, ' ')
    elseif vim.fn.executable(xfce4) == 1 then
      cmd = { xfce4, '--working-directory=' .. dir }
    end
    print(vim.inspect(cmd))
  end
  local ret = vim.fn.jobstart(cmd, { detach = true })
  if ret <= 0 then
    local msg = {
      'Failed to open terminal',
      ret,
      vim.inspect(cmd),
    }
    vim.notify(table.concat(msg, '\n'), vim.log.levels.ERROR)
  end
end

M.copy_to_clipboard = function(content)
  vim.fn.setreg('+', content)
  vim.fn.setreg('"', content)
  return vim.notify(string.format('Copied %s to system clipboard!', vim.inspect(content)), vim.log.levels.INFO)
end

M.is_root = function(path)
  if M.is_windows() then
    if M.nvim_sep() == M.kernel_sep() then
      return string.match(path, '^[A-Z]:/?$')
    else
      return string.match(path, '^[A-Z]:\\?$')
    end
  end
  return path == M.kernel_sep()
end

M.is_absolute = function(path)
  if M.is_windows() then
    if M.nvim_sep() == M.kernel_sep() then
      return string.match(path, '^[%a]:/.*$')
    else
      return string.match(path, '^[%a]:\\.*$')
    end
  end
  return string.sub(path, 1, 1) == M.kernel_sep()
end

M.rfind = function(s, sub)
  return (function()
    local r = { string.find(string.reverse(s), sub, 1, true) }
    return r[2]
  end)()
end

M.path_add_trailing = function(path)
  if path:sub(-1) == M.nvim_sep() then
    return path
  end
  return path .. M.nvim_sep()
end

M.path_relative = function(path, relative_to)
  local _, r = string.find(path, M.path_add_trailing(relative_to), 1, true)
  local p = path
  if r then
    -- take the relative path starting after '/'
    -- if somehow given a completely matching path,
    -- returns ""
    p = path:sub(r + 1)
  end
  return p
end

-- stylua: ignore start
function M.get_content()       return vim.api.nvim_buf_get_text(0, 0, 0, -1, -1, {})                end
function M.get_path()          return M.get_current_buffer_name()                                   end
function M.get_relative_path() return M.path_relative(M.get_current_buffer_name(), vim.fn.getcwd()) end
-- stylua: ignore end

M.get_current_buffer_name = function()
  local name = vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf())
  return M.shellslash_safe(name ~= '' and name or NONAME)
end

function M.is_noname(name)
  return name == NONAME
end

M.name = function()
  local path = M.get_current_buffer_name()
  local i = M.rfind(path, M.nvim_sep())
  return i and string.sub(path, -i + 1, -1) or path
end

M.ext = function()
  local ext = M.name():match('.+%.(%w+)')
end

M.get_name_without_ext = function()
  local name = M.name()
  local i = M.rfind(name, '.')
  return i and string.sub(name, 1, -i - 1) or name
end

M.get_contain_directory = function(path)
  if path == nil then
    path = M.get_current_buffer_name()
  end
  local i = M.rfind(path, M.nvim_sep())
  return i and string.sub(path, 1, #path - i + 1) or nil
end

M.notify = function(msg, opts)
  if vim.in_fast_event() then
    return vim.schedule(function()
      M.notify(msg, opts)
    end)
  end
  opts = opts or {}
  if type(msg) == 'table' then
    msg = table.concat(
      vim.tbl_filter(function(line)
        return line or false
      end, msg),
      '\n'
    )
  end
  vim.notify(msg, opts.level or vim.log.levels.INFO, {
    title = opts.title or 'Notify From Base',
  })
end

M.info = function(msg, opts)
  opts = opts or {}
  opts.level = vim.log.levels.INFO
  M.notify(msg, opts)
end

M.warn = function(msg, opts)
  opts = opts or {}
  opts.level = vim.log.levels.WARN
  M.notify(msg, opts)
end

M.error = function(msg, opts)
  opts = opts or {}
  opts.level = vim.log.levels.ERROR
  M.notify(msg, opts)
end

M.fetch = function(option, _local)
  if _local then
    return vim.opt_local[option]:get()
  end
  return vim.opt[option]:get()
end

M.set = function(option, _local, value, silent)
  if _local then
    vim.opt_local[option] = value
  else
    vim.opt[option] = value
  end
  if not silent then
    M.info('Set ' .. option .. ' to ' .. tostring(value), { title = 'Option Changed' })
  end
end

M.toggle = function(option, _local, msg)
  M.set(option, _local, not M.fetch(option, _local), msg)
  if msg and vim.tbl_count(msg) == 2 then
    if M.fetch(option, _local) then
      M.info(msg[1], { title = 'Option Toggle' })
    else
      M.info(msg[2], { title = 'Option Toggle' })
    end
  end
end

M.g_toggle = function(option, msg)
  if vim.g[option] == nil then
    vim.g[option] = false
  end
  vim.g[option] = not vim.g[option]
  if vim.g[option] == true then
    M.info(msg[1], { title = msg[3] })
  else
    M.info(msg[2], { title = msg[3] })
  end
end

M.has = function(plugin)
  return require('lazy.core.config').plugins[plugin] ~= nil
end

M.on_attach = function(on_attach)
  vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
      local buffer = args.buf
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      on_attach(client, buffer)
    end,
  })
end

M.on_very_lazy = function(fn)
  vim.api.nvim_create_autocmd('User', {
    pattern = 'VeryLazy',
    callback = function()
      fn()
    end,
  })
end

M.root_patterns = { '.git' }

-- returns the root directory based on:
-- * lsp workspace folders
-- * lsp root_dir
-- * root pattern of filename of the current buffer
-- * root pattern of cwd
---@return string
function M.get_root()
  ---@type string?
  local path = vim.api.nvim_buf_get_name(0)
  path = path ~= '' and vim.loop.fs_realpath(path) or nil
  ---@type string[]
  local roots = {}
  if path then
    for _, client in pairs(vim.lsp.get_active_clients({ bufnr = 0 })) do
      local workspace = client.config.workspace_folders
      local paths = workspace and vim.tbl_map(function(ws)
        return vim.uri_to_fname(ws.uri)
      end, workspace) or client.config.root_dir and { client.config.root_dir } or {}
      for _, p in ipairs(paths) do
        local r = vim.loop.fs_realpath(p)
        if path:find(r, 1, true) then
          roots[#roots + 1] = r
        end
      end
    end
  end
  table.sort(roots, function(a, b)
    return #a > #b
  end)
  ---@type string?
  local root = roots[1]
  if not root then
    path = path and vim.fs.dirname(path) or vim.loop.cwd()
    ---@type string?
    root = vim.fs.find(M.root_patterns, { path = path, upward = true })[1]
    root = root and vim.fs.dirname(root) or vim.loop.cwd()
  end
  ---@cast root string
  return root
end

---Require a module using [pcall] and report any errors
---@param module string
---@param opts table?
---@return boolean, any
function M.safe_require(module, opts)
  local fmt = string.format
  opts = opts or { silent = false }
  local ok, result = pcall(require, module)
  if not ok and not opts.silent then
    M.error(result, { title = fmt('Error requiring: %s', module) })
  end
  return ok, result
end

function M.neovim_latest()
  local latest = 'nvim-0.10.0'
  -- OK: vim.fn.has('nvim-0.10.0') == 1
  -- ERROR: vim.fn.has latest == 1
  return vim.fn.has(latest) == 1
end

return M
