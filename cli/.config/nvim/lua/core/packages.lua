if vim.env.NVIM_NOTHIRDPARTY then
  return
end

---Load configuration for a specified package
---@param path string
---@param schedule_wrapped boolean|nil
_G.load_pkg = function(path, schedule_wrapped)
  return schedule_wrapped
      and function()
        vim.schedule(function()
          require('configs.' .. path)
        end)
      end
    or function()
      require('configs.' .. path)
    end
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

  local url = 'https://github.com/folke/lazy.nvim.git'
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
  load_pkg('lazy')()
  vim.keymap.set('n', '<Leader>pp', '<Cmd>Lazy<CR>')
  vim.keymap.set('n', '<Leader>pi', '<Cmd>Lazy install<CR>')
  vim.keymap.set('n', '<Leader>pu', '<Cmd>Lazy update<CR>')
  vim.keymap.set('n', '<Leader>px', '<Cmd>Lazy clean<CR>')
end
