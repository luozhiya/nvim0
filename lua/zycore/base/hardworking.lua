local fn = vim.fn
local api = vim.api
local fmt = string.format
local hardworking = {}

local style_constexpr = require('zycore.base.style_constexpr')

----------------------------------------------------------------------------------------------------
-- API
----------------------------------------------------------------------------------------------------
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
  return api.nvim_strwidth(str) > max_len and str:sub(1, max_len) .. style_constexpr.icons.misc.ellipsis
      or str
end
hardworking.truncate = truncate

---Determine if a value of any type is empty
---@param item any
---@return boolean
local function empty(item)
  if not item then
    return true
  end
  local item_type = type(item)
  if item_type == 'string' then
    return item == ''
  elseif item_type == 'table' then
    return vim.tbl_isempty(item)
  end
end
hardworking.empty = empty

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
local function invalidate(path, recursive)
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
hardworking.invalidate = invalidate

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
