local uv = vim.loop
local fn = vim.fn
local log = vim.log.levels

local M = {}

local rules = {
  -- HTTPS URLs (input: https://host/org/repo)
  {
    pattern = '^https?://([^/]+)/(.+)$',
    replace = 'https://%1/%2',
    format_url = function(base_url, params)
      local single_line_url = string.format(
        '%s/blob/%s/%s#L%d',
        base_url,
        params.branch,
        params.file_path,
        params.start_line
      )
      if params.start_line == params.end_line then
        return single_line_url
      end
      return string.format('%s-L%d', single_line_url, params.end_line)
    end,
  },
  -- SSH URLs with git@ format (input: git@host:org/repo)
  {
    pattern = '^git@([^:]+):',
    replace = 'https://%1/',
    format_url = function(base_url, params)
      local single_line_url = string.format(
        '%s/blob/%s/%s#L%d',
        base_url,
        params.branch,
        params.file_path,
        params.start_line
      )
      if params.start_line == params.end_line then
        return single_line_url
      end
      return string.format('%s-L%d', single_line_url, params.end_line)
    end,
  },
  -- SSH protocol URLs (input: ssh://git@host/org/repo)
  {
    pattern = '^ssh://git@([^:/]+)/',
    replace = 'https://%1/',
    format_url = function(base_url, params)
      local single_line_url = string.format(
        '%s/blob/%s/%s#L%d',
        base_url,
        params.branch,
        params.file_path,
        params.start_line
      )
      if params.start_line == params.end_line then
        return single_line_url
      end
      return string.format('%s-L%d', single_line_url, params.end_line)
    end,
  },
}

---Percent-encode a string for URLs
---@param url string
---@return string
local function encode_url(url)
  return (
    url:gsub('([^A-Za-z0-9_%.~-])', function(c)
      return string.format('%%%02X', string.byte(c))
    end)
  )
end

local function copy_to_clipboard(text)
  fn.setreg('+', text)
  vim.notify('[Git] URL copied to clipboard', log.INFO)
end

---Open URL in browser depending on the system
---@param url string
local function open_url_in_browser(url)
  local sysname = uv.os_uname().sysname
  local cmd
  if sysname == 'Windows_NT' then
    cmd = { 'cmd.exe', '/C', 'start', '', url }
  elseif sysname == 'Darwin' then
    cmd = { 'open', url }
  elseif sysname == 'Linux' then
    cmd = { 'xdg-open', url }
  else
    vim.notify('[Git] OS unsupported, unable to open URL', log.ERROR)
    return
  end
  vim.notify('[Git] Opening URL in browser', log.INFO)
  fn.jobstart(cmd, { detach = true })
end

local function get_default_branch()
  local out =
    fn.systemlist('git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null')
  if vim.v.shell_error == 0 and #out > 0 then
    local full = out[1]:match('refs/remotes/origin/(.+)$')
    if full and #full > 0 then
      return full
    end
  end
  return fn.trim(fn.system('git rev-parse --short HEAD'))
end

local function get_current_branch()
  local branch =
    fn.trim(fn.system('git rev-parse --abbrev-ref HEAD 2>/dev/null'))
  if vim.v.shell_error ~= 0 or branch == '' or branch == 'HEAD' then
    vim.notify('[Git] Could not determine branch, using default', log.WARN)
    return get_default_branch()
  end
  return branch
end

local function get_remote_url()
  local remote_name = 'origin'
  local raw_url = fn.trim(
    fn.system(string.format('git config --get remote.%s.url', remote_name))
  )
  if vim.v.shell_error ~= 0 or raw_url == '' then
    vim.notify(("[Git] No remote '%s' found"):format(remote_name), log.ERROR)
    return nil
  end

  -- Normalize SSH URLs to https:// for matching
  raw_url = raw_url:gsub('^git@([^:]+):', 'https://%1/')

  for _, rule in ipairs(rules) do
    if raw_url:match(rule.pattern) then
      local base = raw_url:gsub(rule.pattern, rule.replace):gsub('%.git$', '')
      return base, rule.format_url
    end
  end

  vim.notify('[Git] No URL rule matched for: ' .. raw_url, log.ERROR)
  return nil
end

local function get_line_range()
  local start_pos = fn.getpos("'<")
  local end_pos = fn.getpos("'>")
  if start_pos[2] ~= 0 and end_pos[2] ~= 0 then
    return math.min(start_pos[2], end_pos[2]),
      math.max(start_pos[2], end_pos[2])
  end
  local cur = fn.getcurpos()
  return cur[2], cur[2]
end

---Get remote URL
---@return string|nil
local function get_url()
  fn.system('git rev-parse --show-toplevel 2>/dev/null')
  if vim.v.shell_error ~= 0 then
    vim.notify('[Git] Not a git repository', log.ERROR)
    return nil
  end

  local cwd = fn.getcwd():gsub('\\', '/')
  local abs_path = fn.expand('%:p'):gsub('\\', '/')
  local rel_path = abs_path:gsub('^' .. vim.pesc(cwd) .. '/', '')

  local tracked = fn.trim(
    fn.system('git ls-files --full-name -- ' .. fn.shellescape(rel_path))
  )
  if vim.v.shell_error ~= 0 or tracked == '' then
    vim.notify('[Git] File is not tracked by git', log.ERROR)
    return nil
  end

  local base_url, fmt = get_remote_url()
  if not base_url or not fmt then
    return nil
  end

  local branch = get_current_branch()
  local start_line, end_line = get_line_range()
  local params = {
    branch = encode_url(branch),
    file_path = encode_url(tracked),
    start_line = start_line,
    end_line = end_line,
  }

  return fmt(base_url, params)
end

M.copy_url = function()
  local url = get_url()
  if url then
    copy_to_clipboard(url)
  end
  vim.fn.mode('normal')
end

M.open_url = function()
  local url = get_url()
  if url then
    open_url_in_browser(url)
  end
end

return M
