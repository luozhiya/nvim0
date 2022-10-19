local M = {}
local zycore = require('zycore')
local packer_dir = require('zycore.plugin').packer_dir

-- local s = {}
-- vim.notify('init finished', vim.log.levels.TRACE, s)

local ensure_installed = function(user, repo)
  local ok, results = pcall(vim.fs.find, repo, { path = packer_dir, type = 'directory' })
  if not ok or #results == 0 then
    local cmd = string.format('!git clone https://github.com/%s/%s %s/start/%s', user, repo, packer_dir, repo)
    vim.cmd(cmd)
    vim.cmd('packadd ' .. repo)
  end
end

ensure_installed("Olical", "aniseed")

vim.g["aniseed#env"] = {
  module = "zylisp.init",
  compile = true
}

return M
