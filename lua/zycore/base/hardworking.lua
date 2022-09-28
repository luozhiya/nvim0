local fn = vim.fn
local api = vim.api
local fmt = string.format
local style_constexpr = require('zycore.base.style_constexpr')

local hardworking = {}

----------------------------------------------------------------------------------------------------
-- Environment
----------------------------------------------------------------------------------------------------
local is_windows = function()
  return fn.has('win32') == 1 or fn.has('win64') == 1
end
hardworking.is_windows = is_windows

local is_linux = function()
  return fn.has('unix') == 1 and not fn.has('macunix') == 1 and not fn.has('win32unix') == 1
end
hardworking.is_linux = is_linux

local is_osx = function()
  return fn.has('macunix') == 1
end
hardworking.is_osx = is_osx

local is_wsl = function()
  return fn.has('wsl')
end
hardworking.is_wsl = is_wsl

local is_gui_running = function()
  return fn.has('gui_running')
end
hardworking.is_gui_running = is_gui_running

----------------------------------------------------------------------------------------------------
-- API
----------------------------------------------------------------------------------------------------
---Create once callback
---@param callback function
---@return function
local once = function(callback)
  local done = false
  return function(...)
    if done then
      return
    end
    done = true
    callback(...)
  end
end
hardworking.once = once

---Return concatenated list
---@param list1 any[]
---@param list2 any[]
---@return any[]
local concat = function(list1, list2)
  local new_list = {}
  for _, v in ipairs(list1) do
    table.insert(new_list, v)
  end
  for _, v in ipairs(list2) do
    table.insert(new_list, v)
  end
  return new_list
end
hardworking.concat = concat

---Repeat values
---@generic T
---@param str_or_tbl T
---@param count integer
---@return T
hardworking.rep = function(str_or_tbl, count)
  if type(str_or_tbl) == 'string' then
    return string.rep(str_or_tbl, count)
  end
  local rep = {}
  for _ = 1, count do
    for _, v in ipairs(str_or_tbl) do
      table.insert(rep, v)
    end
  end
  return rep
end

---Return the valu is empty or not.
---@param v any
---@return boolean
hardworking.empty = function(v)
  if not v then
    return true
  end
  if v == vim.NIL then
    return true
  end
  if type(v) == 'string' and v == '' then
    return true
  end
  if type(v) == 'table' and vim.tbl_isempty(v) then
    return true
  end
  if type(v) == 'number' and v == 0 then
    return true
  end
  return false
end

hardworking.dump = function(tbl, depth)
  if (depth > 100) then
    print("Too many depth")
    return
  end
  for k, v in pairs(tbl) do
    if (type(v) == 'table') then
      print(string.rep('  ', depth) .. k .. ': ')
      hardworking.dump(v, depth + 1)
    else
      print(string.rep('  ', depth) .. k .. ': ' .. v)
    end
  end
end

hardworking.merge_simple_list = function(v1, v2)
  local ret = {}
  for k, v in pairs(v1) do
    ret[k] = v
  end
  local ofs = vim.tbl_count(ret)
  for k, v in pairs(v2) do
    ret[k + ofs] = v
  end
  return ret
end

---The symbol to remove key in misc.merge.
hardworking.none = vim.NIL

---Merge two tables recursively
---@generic T
---@param v1 T
---@param v2 T
---@return T
hardworking.merge = function(v1, v2)
  local merge1 = type(v1) == 'table' and (not vim.tbl_islist(v1) or vim.tbl_isempty(v1))
  local merge2 = type(v2) == 'table' and (not vim.tbl_islist(v2) or vim.tbl_isempty(v2))
  if merge1 and merge2 then
    local new_tbl = {}
    for k, v in pairs(v2) do
      new_tbl[k] = hardworking.merge(v1[k], v)
    end
    for k, v in pairs(v1) do
      if v2[k] == nil and v ~= hardworking.none then
        new_tbl[k] = v
      end
    end
    return new_tbl
  end
  if v1 == hardworking.none then
    return nil
  end
  if v1 == nil then
    if v2 == hardworking.none then
      return nil
    else
      return v2
    end
  end
  if v1 == true then
    if merge2 then
      return v2
    end
    return {}
  end

  return v1
end

---Generate id for group name
hardworking.id = setmetatable({
  group = {},
}, {
  __call = function(_, group)
    hardworking.id.group[group] = hardworking.id.group[group] or 0
    hardworking.id.group[group] = hardworking.id.group[group] + 1
    return hardworking.id.group[group]
  end,
})

---Check the value is nil or not.
---@generic T|nil|vim.NIL
---@param v T
---@return T|nil
local function safe(v)
  if v == nil or v == vim.NIL then
    return nil
  end
  return v
end

hardworking.safe = safe

---Treat 1/0 as bool value
---@param v boolean|1|0
---@param def boolean
---@return boolean
hardworking.bool = function(v, def)
  if hardworking.safe(v) == nil then
    return def
  end
  return v == true or v == 1
end

---Set value to deep object
---@param t table
---@param keys string[]
---@param v any
local function set(t, keys, v)
  local c = t
  for i = 1, #keys - 1 do
    local key = keys[i]
    c[key] = hardworking.safe(c[key]) or {}
    c = c[key]
  end
  c[keys[#keys]] = v
end

hardworking.set = set

---Copy table
---@generic T
---@param tbl T
---@return T
hardworking.copy = function(tbl)
  if type(tbl) ~= 'table' then
    return tbl
  end

  if vim.tbl_islist(tbl) then
    local copy = {}
    for i, value in ipairs(tbl) do
      copy[i] = hardworking.copy(value)
    end
    return copy
  end

  local copy = {}
  for key, value in pairs(tbl) do
    copy[key] = hardworking.copy(value)
  end
  return copy
end

---Safe version of vim.str_utfindex
---@param text string
---@param vimindex integer|nil
---@return integer
hardworking.to_utfindex = function(text, vimindex)
  vimindex = vimindex or #text + 1
  return vim.str_utfindex(text, math.max(0, math.min(vimindex - 1, #text)))
end

---Safe version of vim.str_byteindex
---@param text string
---@param utfindex integer
---@return integer
hardworking.to_vimindex = function(text, utfindex)
  utfindex = utfindex or #text
  for i = utfindex, 1, -1 do
    local s, v = pcall(function()
      return vim.str_byteindex(text, i) + 1
    end)
    if s then
      return v
    end
  end
  return utfindex + 1
end

---Mark the function as deprecated
hardworking.deprecated = function(fn, msg)
  local printed = false
  return function(...)
    if not printed then
      print(msg)
      printed = true
    end
    return fn(...)
  end
end

--Redraw
hardworking.redraw = setmetatable({
  doing = false,
  force = false,
  -- We use `<Up><Down>` to redraw the screen. (Previously, We use <C-r><ESC>. it will remove the unmatches search history.)
  incsearch_redraw_keys = '<Up><Down>',
}, {
  __call = function(self, force)
    local termcode = vim.api.nvim_replace_termcodes(self.incsearch_redraw_keys, true, true, true)
    if vim.tbl_contains({ '/', '?' }, vim.fn.getcmdtype()) then
      if vim.o.incsearch then
        return vim.api.nvim_feedkeys(termcode, 'in', true)
      end
    end

    if self.doing then
      return
    end
    self.doing = true
    self.force = not not force
    vim.schedule(function()
      if self.force then
        vim.cmd([[redraw!]])
      else
        vim.cmd([[redraw]])
      end
      self.doing = false
      self.force = false
    end)
  end,
})

---Find an item in a list
---@generic T
---@param haystack T[]
---@param matcher fun(arg: T):boolean
---@return T
local function find(haystack, matcher)
  local found
  for _, needle in ipairs(haystack) do
    if matcher(needle) then
      found = needle
      break
    end
  end
  return found
end

hardworking.find = find

local installed
---Check if a plugin is on the system not whether or not it is loaded
---@param plugin_name string
---@return boolean
local function plugin_installed(plugin_name)
  if not installed then
    local dirs = fn.expand(fn.stdpath('data') .. '/site/pack/packer/start/*', true, true)
    local opt = fn.expand(fn.stdpath('data') .. '/site/pack/packer/opt/*', true, true)
    vim.list_extend(dirs, opt)
    installed = vim.tbl_map(function(path)
      return fn.fnamemodify(path, ':t')
    end, dirs)
  end
  return vim.tbl_contains(installed, plugin_name)
end

hardworking.plugin_installed = plugin_installed

---NOTE: this plugin returns the currently loaded state of a plugin given
---given certain assumptions i.e. it will only be true if the plugin has been
---loaded e.g. lazy loading will return false
---@param plugin_name string
---@return boolean?
local function plugin_loaded(plugin_name)
  local plugins = packer_plugins or {}
  return plugins[plugin_name] and plugins[plugin_name].loaded
end

hardworking.plugin_loaded = plugin_loaded

---Check whether or not the location or quickfix list is open
---@return boolean
local function is_vim_list_open()
  for _, win in ipairs(api.nvim_list_wins()) do
    local buf = api.nvim_win_get_buf(win)
    local location_list = fn.getloclist(0, { filewinid = 0 })
    local is_loc_list = location_list.filewinid > 0
    if vim.bo[buf].filetype == 'qf' or is_loc_list then
      return true
    end
  end
  return false
end

hardworking.is_vim_list_open = is_vim_list_open

local function truncate(str, max_len)
  assert(str and max_len, 'string and max_len must be provided')
  return api.nvim_strwidth(str) > max_len
      and str:sub(1, max_len) .. style_constexpr.icons.misc.ellipsis
      or str
end

hardworking.truncate = truncate

---Require a module using [pcall] and report any errors
---@param module string
---@param opts table?
---@return boolean, any
local function safe_require(module, opts)
  opts = opts or { silent = false }
  local ok, result = pcall(require, module)
  if not ok and not opts.silent then
    vim.notify(result, vim.log.levels.ERROR, { title = fmt('Error requiring: %s', module) })
  end
  return ok, result
end

hardworking.safe_require = safe_require

---Reload lua modules
---@param path string
---@param recursive string
local function reload_lua_module(path, recursive)
  if recursive then
    for key, value in pairs(package.loaded) do
      if key ~= '_G' and value and fn.match(key, path) ~= -1 then
        package.loaded[key] = nil
        require(key)
      end
    end
  else
    package.loaded[path] = nil
    require(path)
  end
end

hardworking.reload_lua_module = reload_lua_module

--- Usage:
--- 1. Call `local stop = utils.profile('my-log')` at the top of the file
--- 2. At the bottom of the file call `stop()`
--- 3. Restart neovim, the newly created log file should open
local function profile(filename)
  local base = '/tmp/config/profile/'
  fn.mkdir(base, 'p')
  local success, profile = pcall(require, 'plenary.profile.lua_profiler')
  if not success then
    vim.api.nvim_echo({ 'Plenary is not installed.', 'Title' }, true, {})
  end
  profile.start()
  return function()
    profile.stop()
    local logfile = base .. filename .. '.log'
    profile.report(logfile)
    vim.defer_fn(function()
      vim.cmd('tabedit ' .. logfile)
    end, 1000)
  end
end

hardworking.profile = profile

----------------------------------------------------------------------------------------------------
-- API Wrappers
----------------------------------------------------------------------------------------------------
-- Thin wrappers over API functions to make their usage easier/terser

---@class Autocommand
---@field description string
---@field event  string[] list of autocommand events
---@field pattern string[] list of autocommand patterns
---@field command string | function
---@field nested  boolean
---@field once    boolean
---@field buffer  number

---Create an autocommand
---returns the group ID so that it can be cleared or manipulated.
---@param name string
---@param commands Autocommand[]
---@return number
local function augroup(name, commands)
  local id = api.nvim_create_augroup(name, { clear = true })
  for _, autocmd in ipairs(commands) do
    local is_callback = type(autocmd.command) == 'function'
    api.nvim_create_autocmd(autocmd.event, {
      group = name,
      pattern = autocmd.pattern,
      desc = autocmd.description,
      callback = is_callback and autocmd.command or nil,
      command = not is_callback and autocmd.command or nil,
      once = autocmd.once,
      nested = autocmd.nested,
      buffer = autocmd.buffer,
    })
  end
  return id
end

hardworking.augroup = augroup

--- @class CommandArgs
--- @field args string
--- @field fargs table
--- @field bang boolean,

---Create an nvim command
---@param name any
---@param rhs string|fun(args: CommandArgs)
---@param opts table?
local function command(name, rhs, opts)
  opts = opts or {}
  api.nvim_create_user_command(name, rhs, opts)
end

hardworking.command = command

---Source a lua or vimscript file
---@param path string path relative to the nvim directory
---@param prefix boolean?
local function source(path, prefix)
  if not prefix then
    vim.cmd(fmt('source %s', path))
  else
    vim.cmd(fmt('source %s/%s', vim.g.vim_dir, path))
  end
end

hardworking.source = source

---Check if a cmd is executable
---@param e string
---@return boolean
local function executable(e)
  return fn.executable(e) > 0
end

hardworking.executable = executable

---A terser proxy for `nvim_replace_termcodes`
---@param str string
---@return string
local function replace_termcodes(str)
  return api.nvim_replace_termcodes(str, true, true, true)
end

hardworking.replace_termcodes = replace_termcodes

---check if a certain feature/version/commit exists in nvim
---@param feature string
---@return boolean
local function has(feature)
  return vim.fn.has(feature) > 0
end

hardworking.has = has

----------------------------------------------------------------------------------------------------
-- Mappings
----------------------------------------------------------------------------------------------------

---create a mapping function factory
---@param mode string
---@param o table
---@return fun(lhs: string, rhs: string|function, opts: table|nil) 'create a mapping'
local function make_mapper(mode, o)
  -- copy the opts table as extends will mutate the opts table passed in otherwise
  local parent_opts = vim.deepcopy(o)
  ---Create a mapping
  ---@param lhs string
  ---@param rhs string|function
  ---@param opts table
  return function(lhs, rhs, opts)
    -- If the label is all that was passed in, set the opts automagically
    opts = type(opts) == 'string' and { desc = opts } or opts and vim.deepcopy(opts) or {}
    vim.keymap.set(mode, lhs, rhs, vim.tbl_extend('keep', opts, parent_opts))
  end
end

hardworking.make_mapper = make_mapper

local map_opts = { remap = true, silent = true }
local noremap_opts = { silent = true }

-- A recursive commandline mapping
local nmap = make_mapper('n', map_opts)
hardworking.nmap = nmap

-- A recursive select mapping
local xmap = make_mapper('x', map_opts)
hardworking.xmap = xmap

-- A recursive terminal mapping
local imap = make_mapper('i', map_opts)
hardworking.imap = imap

-- A recursive operator mapping
local vmap = make_mapper('v', map_opts)
hardworking.vmap = vmap

-- A recursive insert mapping
local omap = make_mapper('o', map_opts)
hardworking.omap = omap

-- A recursive visual & select mapping
local tmap = make_mapper('t', map_opts)
hardworking.tmap = tmap

-- A recursive visual mapping
local smap = make_mapper('s', map_opts)
hardworking.smap = smap

-- A recursive normal mapping
local cmap = make_mapper('c', { remap = true, silent = false })
hardworking.cmap = cmap

-- A non recursive normal mapping
local nnoremap = make_mapper('n', noremap_opts)
hardworking.nnoremap = nnoremap

-- A non recursive visual mapping
local xnoremap = make_mapper('x', noremap_opts)
hardworking.xnoremap = xnoremap

-- A non recursive visual & select mapping
local vnoremap = make_mapper('v', noremap_opts)
hardworking.vnoremap = vnoremap

-- A non recursive insert mapping
local inoremap = make_mapper('i', noremap_opts)
hardworking.inoremap = inoremap

-- A non recursive operator mapping
local onoremap = make_mapper('o', noremap_opts)
hardworking.onoremap = onoremap

-- A non recursive terminal mapping
local tnoremap = make_mapper('t', noremap_opts)
hardworking.tnoremap = tnoremap

-- A non recursive select mapping
local snoremap = make_mapper('s', noremap_opts)
hardworking.snoremap = snoremap

-- A non recursive commandline mapping
local cnoremap = make_mapper('c', { silent = false })
hardworking.cnoremap = cnoremap

return hardworking
