local utils = {
  fs = require('my.utils.fs'),
  hl = require('my.utils.hl'),
  stl = require('my.utils.stl'),
}
local groupid = vim.api.nvim_create_augroup('StatusLine', {})

_G._statusline = {}

---Record file name of normal buffers, key:val = fname:buffers_with_fname
---@type table<string, number[]>
local fnames = {}

---Update path diffs for buffers with the same file name
---@param bufs integer[]
---@return nil
local function update_pdiffs(bufs)
  bufs = vim.tbl_filter(vim.api.nvim_buf_is_valid, bufs)

  local path_diffs =
    utils.fs.diff(vim.tbl_map(vim.api.nvim_buf_get_name, bufs))

  for i, buf in ipairs(bufs) do
    if path_diffs[i] ~= '' then
      vim.b[buf]._stl_pdiff = path_diffs[i]
    end
  end
end

---Check if buffer is visible
---A buffer is considered visible if it is listed or has a corresponding window
---@param buf integer buffer number
---@return boolean
local function buf_visible(buf)
  return vim.api.nvim_buf_is_valid(buf)
    and (vim.bo[buf].bl or vim.fn.bufwinid(buf) ~= -1)
end

---Add a buffer to `fnames`, calc diff for buffer with non-unique file names
---@param buf integer buffer number
---@return nil
local function add_buf(buf)
  if not buf_visible(buf) then
    return
  end
  local bufname = vim.api.nvim_buf_get_name(buf)
  if bufname == '' then
    return
  end

  local clean = bufname:gsub('^%s*%S+://', ''):gsub('/$', '')
  local fname = vim.fs.basename(clean)

  if fname == '' then
    return
  end

  if not fnames[fname] then
    fnames[fname] = {}
  end

  local bufs = fnames[fname] -- buffers with the same name as the removed buf
  if not vim.tbl_contains(bufs, buf) then
    table.insert(bufs, buf)
    update_pdiffs(bufs)
  end
end

---Remove a buffer from `fnames` and update path diffs
---@param buf integer buffer number
---@param bufname string buffer name, `buf` may not be valid so we need this
---@return nil
local function remove_buf(buf, bufname)
  if buf_visible(buf) then
    return
  end

  local clean = bufname:gsub('^%s*%S+://', ''):gsub('/$', '')
  local fname_key = vim.fs.basename(clean)

  local bufs = fnames[fname_key]
  if not bufs then
    return
  end

  for i, b in ipairs(bufs) do
    if b == buf then
      table.remove(bufs, i)
      break
    end
  end

  local num_bufs = #bufs
  if num_bufs == 0 then
    fnames[fname_key] = nil
    return
  end

  -- If only one buffer remains with this name, it no longer needs a path diff
  if num_bufs == 1 then
    if vim.api.nvim_buf_is_valid(bufs[1]) then
      vim.b[bufs[1]]._stl_pdiff = nil
    end
    return
  end

  -- Still have multiple buffers with the same name, update their diffs
  update_pdiffs(bufs)
end

for _, buf in ipairs(vim.api.nvim_list_bufs()) do
  add_buf(buf)
end

vim.api.nvim_create_autocmd({ 'BufAdd', 'BufWinEnter', 'BufFilePost' }, {
  desc = 'Track new buffer file name.',
  group = groupid,
  -- Delay adding buffer to fnames to ensure attributes, e.g.
  -- `bt`, are set for special buffers, for example, terminal buffers
  callback = vim.schedule_wrap(function(args)
    add_buf(args.buf)
    pcall(vim.cmd.redrawstatus, {
      bang = true,
      mods = { emsg_silent = true },
    })
  end),
})

vim.api.nvim_create_autocmd('OptionSet', {
  desc = 'Remove invisible buffer record.',
  group = groupid,
  pattern = 'buflisted',
  callback = function(args)
    remove_buf(args.buf, args.file)
    -- For some reason, invoking `:redrawstatus` directly makes oil.nvim open
    -- a floating window shortly before opening a file
    vim.schedule(function()
      pcall(vim.cmd.redrawstatus, {
        bang = true,
        mods = { emsg_silent = true },
      })
    end)
  end,
})

vim.api.nvim_create_autocmd({
  'BufLeave',
  'BufHidden',
  'BufDelete',
  'BufFilePre',
}, {
  desc = 'Remove invisible buffer from record.',
  group = groupid,
  callback = vim.schedule_wrap(function(args)
    remove_buf(args.buf, args.file)
  end),
})

vim.api.nvim_create_autocmd('WinClosed', {
  group = groupid,
  callback = function(args)
    local win = tonumber(args.match)
    if not win or not vim.api.nvim_win_is_valid(win) then
      return
    end
    local buf = vim.api.nvim_win_get_buf(win)
    local bufname = vim.api.nvim_buf_get_name(buf)
    vim.schedule(function()
      remove_buf(buf, bufname)
    end)
  end,
})

local function raw_fname()
  local bufname = vim.api.nvim_buf_get_name(0)
  if bufname == '' then
    return '[No Name]'
  end

  local clean = bufname:gsub('^%s*%S+://', ''):gsub('/$', '')
  local display_name = vim.fs.basename(clean)

  if display_name == '' then
    display_name = clean
  end

  if vim.bo.bt == 'quickfix' then
    return vim.w.quickfix_title or '[No Name]'
  end

  if vim.bo.ft == 'fugitive' then
    local path = vim.fs.root(0, '.git') or ''
    path = vim.fn.fnamemodify(path, ':~')
    return string.format('%s', path)
  end

  local pdiff = vim.b._stl_pdiff
  if pdiff and pdiff ~= '' then
    display_name = string.format('%s [%s]', display_name, pdiff)
  end

  return utils.stl.escape(display_name)
end

---Get Emacs-like position: "Scroll (Line,Col)   "
---@return string
function _G._statusline.pos()
  local line = vim.fn.line('.')
  local col = vim.fn.virtcol('.')
  local total = vim.fn.line('$')

  local win_top = vim.fn.line('w0')
  local win_bot = vim.fn.line('w$')
  local win_h = vim.api.nvim_win_get_height(0)

  local view
  if win_top == 1 and win_bot == total then
    view = 'All'
  elseif win_top == 1 then
    view = 'Top'
  elseif win_bot == total then
    view = 'Bot'
  else
    local percentage = math.floor((win_top - 1) / (total - win_h) * 100)
    view = string.format('%2d%%%%', math.max(0, math.min(99, percentage)))
  end

  local str = string.format('%s  (%d,%d)', view, line, col)

  return string.format('%-16s   ', str)
end

---Get Emacs-like state block
---@return string
function _G._statusline.state()
  local fenc = (vim.bo.fenc ~= '' and vim.bo.fenc or vim.o.enc):upper()
  local encoding_part = fenc:sub(1, 1) -- i.e. 'U' for UTF-8

  local ff = vim.bo.fileformat
  local format_part = ff == 'unix' and '(Unix)'
    or (ff == 'dos' and '\\' or '(Mac)')

  local rw_part = vim.bo.readonly and '%%%%'
    or vim.bo.modified and '**'
    or '--'

  local is_remote = false -- TODO: To be implemented
  local remote_part = is_remote and '@' or '-'

  -- Format: U(Unix)---
  local state_str =
    string.format('%s%s%s%s', encoding_part, format_part, rw_part, remote_part)

  return string.format('%s  ', state_str)
end

---Get file name
---@return string
function _G._statusline.fname()
  return string.format('%-30s   ', raw_fname())
end

---Get diff stats for current buffer
---@param nc boolean
---@return string
function _G._statusline.gitdiff(nc)
  -- Integration with gitsigns.nvim
  ---@diagnostic disable-next-line: undefined-field
  local diff = vim.b.gitsigns_status_dict
    or { added = 0, changed = 0, removed = 0 }
  local added = diff.added or 0
  local changed = diff.changed or 0
  local removed = diff.removed or 0
  if added == 0 and removed == 0 and changed == 0 then
    return ''
  end
  return string.format(
    '+%s~%s-%s',
    utils.stl.hl(tostring(added), 'StatusLineGitAdded' .. (nc and 'NC' or '')),
    utils.stl.hl(
      tostring(changed),
      'StatusLineGitChanged' .. (nc and 'NC' or '')
    ),
    utils.stl.hl(
      tostring(removed),
      'StatusLineGitRemoved' .. (nc and 'NC' or '')
    )
  )
end

---Get string representation of current git branch
---@return string
function _G._statusline.gitbranch()
  ---@diagnostic disable-next-line: undefined-field
  local branch = vim.b.gitsigns_status_dict and vim.b.gitsigns_status_dict.head
    or ''
  if branch == '' then
    return ''
  end

  return '#' .. utils.stl.escape(branch)
end

vim.api.nvim_create_autocmd('DiagnosticChanged', {
  group = groupid,
  desc = 'Update diagnostics cache for the status line.',
  callback = function(info)
    local b = vim.b[info.buf]
    local diag_cnt_cache = { 0, 0, 0, 0 }
    for _, diagnostic in ipairs(info.data.diagnostics) do
      diag_cnt_cache[diagnostic.severity] = diag_cnt_cache[diagnostic.severity]
        + 1
    end
    b.diag_str_cache = nil
    b.diag_str_cache_nc = nil
    b.diag_cnt_cache = diag_cnt_cache
  end,
})

---Get string representation of diagnostics for current buffer
---@param nc boolean
---@return string
function _G._statusline.diag(nc)
  local cache_name = 'diag_str_cache' .. (nc and '_nc' or '')
  if vim.b[cache_name] then
    return vim.b[cache_name]
  end
  local str = ''
  local buf_cnt = vim.b.diag_cnt_cache or {}
  for serverity_nr, severity in ipairs({ 'Error', 'Warn', 'Info', 'Hint' }) do
    local cnt = buf_cnt[serverity_nr] or 0
    if cnt > 0 then
      local hl = 'StatusLineDiagnostic' .. severity .. (nc and 'NC' or '')
      str = str .. (str == '' and '' or ' ') .. utils.stl.hl(cnt, hl)
    end
  end
  vim.b[cache_name] = str
  return str
end

---Get current filetype
---@return string
function _G._statusline.ft()
  local ft = vim.bo.ft == '' and '' or vim.bo.ft
  if ft == '' then
    return ''
  end
  return ft:sub(1, 1):upper() .. ft:sub(2)
end

---Additional info for the current buffer enclosed in parentheses
---@param nc boolean
---@return string
function _G._statusline.info(nc)
  local info = {}
  ---@param section string
  local function add_section(section)
    if section ~= '' then
      table.insert(info, section)
    end
  end

  add_section(_G._statusline.ft())
  add_section(_G._statusline.gitbranch())
  add_section(_G._statusline.gitdiff(nc))
  add_section(_G._statusline.diag(nc))
  return vim.tbl_isempty(info) and ''
    or string.format('(%s) ', table.concat(info, ', '))
end

-- stylua: ignore start
---Statusline components
---@type table<string, string>
local components = {
  state        = [[%{%v:lua.require'my.plugins.eline'.state()%}]],
  fname        = [[%{%v:lua.require'my.plugins.eline'.fname()%}]],
  info         = [[%{%v:lua.require'my.plugins.eline'.info(v:false)%}]],
  info_nc      = [[%{%v:lua.require'my.plugins.eline'.info(v:true)%}]],
  pos          = [[%{%v:lua.require'my.plugins.eline'.pos()%}]],
  align        = [[%=]],
  padding      = [[ ]],
  truncate     = [[%<]],
}
-- stylua: ignore end

local stl = table.concat({
  components.padding,
  components.state,
  components.fname,
  components.pos,
  components.info,
  components.align,
  components.truncate,
  components.padding,
})

local stl_nc = table.concat({
  components.padding,
  components.state,
  components.fname,
  components.pos,
  components.info_nc,
  components.align,
  components.truncate,
  components.padding,
})

setmetatable(_G._statusline, {
  ---Get statusline string
  ---@return string
  __call = function()
    return vim.g.statusline_winid == vim.api.nvim_get_current_win() and stl
      or stl_nc
  end,
})

---Set default highlight groups for statusline components
---@return  nil
local function set_default_hlgroups()
  local default_attr = utils.hl.get(0, {
    name = 'StatusLine',
    link = false,
    winhl_link = false,
  })
  local default_nc_attr = utils.hl.get(0, {
    name = 'StatusLineNC',
    link = false,
    winhl_link = false,
  })

  ---@param hlgroup_name string
  ---@param attr table
  ---@return nil
  local function sethl(hlgroup_name, attr)
    local merged_attr = vim.tbl_deep_extend('keep', attr, default_attr)
    local merged_nc_attr = vim.tbl_deep_extend('keep', attr, default_nc_attr)
    utils.hl.set_default(0, hlgroup_name, merged_attr)
    utils.hl.set_default(0, hlgroup_name .. 'NC', merged_nc_attr)
  end
  -- stylua: ignore start
  sethl('StatusLineGitAdded', { fg = 'GitSignsAdd' })
  sethl('StatusLineGitChanged', { fg = 'GitSignsChange' })
  sethl('StatusLineGitRemoved', { fg = 'GitSignsDelete' })
  sethl('StatusLineDiagnosticHint', { fg = 'DiagnosticSignHint' })
  sethl('StatusLineDiagnosticInfo', { fg = 'DiagnosticSignInfo' })
  sethl('StatusLineDiagnosticWarn', { fg = 'DiagnosticSignWarn' })
  sethl('StatusLineDiagnosticError', { fg = 'DiagnosticSignError' })
  -- stylua: ignore end
end
set_default_hlgroups()

vim.api.nvim_create_autocmd('ColorScheme', {
  group = groupid,
  callback = set_default_hlgroups,
})

return _G._statusline
