if vim.env.NVIM_NOTHIRDPARTY then
  return
end

local utils = require('utils')
local conf_path = vim.fn.stdpath('config') --[[@as string]]
local data_path = vim.fn.stdpath('data') --[[@as string]]

---@return boolean
local function bootstrap()
  vim.g.package_path = vim.fs.joinpath(data_path, 'packages')
  vim.g.package_lock = vim.fs.joinpath(conf_path, 'package-lock.json')
  local lazy_path = vim.fs.joinpath(vim.g.package_path, 'lazy.nvim')
  if vim.uv.fs_stat(lazy_path) then
    vim.opt.rtp:prepend(lazy_path)
    return true
  end

  local url = 'git@github.com:folke/lazy.nvim.git'
  vim.notify('[packages] installing lazy.nvim...')
  vim.fn.mkdir(vim.g.package_path, 'p')
  if
    not utils.git.execute({
      'clone',
      '--filter=blob:none',
      url,
      lazy_path,
    }, vim.log.levels.INFO).success
  then
    return false
  end

  vim.notify('[packages] lazy.nvim cloned to ' .. lazy_path)
  vim.opt.rtp:prepend(lazy_path)
  return true
end

if bootstrap() then
  require('configs.lazy')
end
