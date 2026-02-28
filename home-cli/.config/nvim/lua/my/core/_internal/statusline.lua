local icons = require('my.utils.icons')
local utils = require('my.utils')
local groupid = vim.api.nvim_create_augroup('StatusLine', {})

_G._statusline = {}

-- Maximum widths
local gitbranch_max_width = 0.2
local fname_max_width = 0.4
local fname_special_max_width = 0.8
local fname_ext_max_width = 0.2
local fname_prefix_suffix_max_width = 0.2

---Shorten string to a percentage of statusline width
---@param str string
---@param percent number
---@param str_alt? string alternate string to use when `str` exceeds max width
---@return string
local function str_shorten(str, percent, str_alt)
  str = tostring(str)

  local stl_width = vim.go.laststatus == 3 and vim.go.columns
    or vim.api.nvim_win_get_width(0)
  local max_width = math.ceil(stl_width * percent)
  local str_width = vim.fn.strdisplaywidth(str)
  if str_width <= max_width then
    return str
  end

  if str_alt then
    return str_alt
  end

  local ellipsis = vim.trim(icons.Ellipsis)
  local ellipsis_width = vim.fn.strdisplaywidth(ellipsis)
  local max_substr_width = max_width - ellipsis_width

  -- Ellipsis itself is wider than allowed substring width
  if max_substr_width <= 0 then
    return str:sub(1, 1)
  end

  -- Since a character can have length >= 1, we can only truncate more not less
  -- than desired
  local width_diff = str_width - max_substr_width
  local substr_nchars = math.max(1, vim.fn.strcharlen(str) - width_diff)

  return vim.fn.strcharpart(str, 0, substr_nchars) .. ellipsis
end

---@param bufname string
---@return string path
---@return string pid
---@return string cmd
---@return string name
local function parse_term_name(bufname)
  local path, pid, cmd, name =
    bufname:match('^term://(.*)//(%d+):([^#]*)%s*#?%s*(.*)')
  return vim.fn.fnamemodify(vim.trim(path or ''), ':p'),
    vim.trim(pid or ''),
    vim.trim(cmd or ''),
    vim.trim(name or '')
end

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

  local fname = vim.fs.basename(vim.api.nvim_buf_get_name(buf))
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

  bufname = vim.fs.basename(bufname)
  local bufs = fnames[bufname] -- buffers with the same name as the removed buf
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
    fnames[bufname] = nil
    return
  end

  if num_bufs == 1 then
    if vim.api.nvim_buf_is_valid(bufs[1]) then
      vim.b[bufs[1]]._stl_pdiff = nil
    end
    return
  end

  -- Still have multiple buffers with the same file name,
  -- update path diffs for the remaining buffers
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

---Get file name
---@return string
function _G._statusline.fname()
  local bufname = vim.api.nvim_buf_get_name(0)
  local fname_root = vim.fn.fnamemodify(bufname, ':t:r')
  local fname_ext = vim.fn.fnamemodify(bufname, ':e')
  local fname_short = string.format(
    '%s%s%s',
    str_shorten(fname_root, fname_max_width),
    fname_root ~= '' and fname_ext ~= '' and '.' or '',
    str_shorten(fname_ext, fname_ext_max_width)
  )

  if vim.bo.bt == '' then
    if bufname == '' then
      return '[buffer %n]'
    end
    -- Named normal buffer, show file name, if the file name is not unique,
    -- show local cwd (often project root) after the file name
    local pdiff_short = vim.b._stl_pdiff
      and str_shorten(vim.b._stl_pdiff, fname_prefix_suffix_max_width)
    if pdiff_short then
      return string.format(
        '%s [%s]',
        utils.stl.escape(fname_short),
        utils.stl.escape(pdiff_short)
      )
    end
    return utils.stl.escape(fname_short)
  end

  if vim.bo.bt == 'terminal' then
    local path, pid, cmd, comment = parse_term_name(bufname)
    if not path or not pid or not cmd then
      return string.format(
        '[terminal] %s',
        str_shorten(bufname, fname_max_width)
      )
    end
    return string.format(
      '[terminal %s] %s [%s]',
      str_shorten(
        comment ~= '' and comment or pid,
        fname_prefix_suffix_max_width
      ),
      str_shorten(cmd, fname_max_width),
      str_shorten(
        vim.fn.fnamemodify(path, ':~'):gsub('/+$', ''),
        fname_prefix_suffix_max_width
      )
    )
  end

  if vim.bo.bt == 'quickfix' then
    return '[quickfix]' .. (vim.w.quickfix_title or 'empty')
  end

  local prefix, main = bufname:match('^%s*(%S+)://(.*)')
  if prefix and main then
    return utils.stl.escape(
      string.format(
        '[%s] %s',
        str_shorten(vim.fs.basename(prefix), fname_prefix_suffix_max_width),
        str_shorten(main, fname_special_max_width)
      )
    )
  end

  return str_shorten(
    vim.api.nvim_eval_statusline('%F', {}).str,
    fname_max_width
  )
end

---Get diff stats for current buffer
---@return string
function _G._statusline.gitdiff()
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
    utils.stl.hl(tostring(added), 'StatusLineGitAdded'),
    utils.stl.hl(tostring(changed), 'StatusLineGitChanged'),
    utils.stl.hl(tostring(removed), 'StatusLineGitRemoved')
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

  return '#' .. utils.stl.escape(str_shorten(branch, gitbranch_max_width))
end

---Get current filetype
---@return string
function _G._statusline.ft()
  return vim.bo.ft == '' and '' or vim.bo.ft
end

---Additional info for the current buffer enclosed in parentheses
---@return string
function _G._statusline.info()
  if vim.bo.bt ~= '' then
    return ''
  end

  local info = {}
  ---@param section string
  local function add_section(section)
    if section ~= '' then
      table.insert(info, section)
    end
  end

  add_section(_G._statusline.ft())
  add_section(_G._statusline.gitbranch())
  add_section(_G._statusline.gitdiff())
  return vim.tbl_isempty(info) and ''
    or string.format('(%s) ', table.concat(info, ', '))
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
    b.diag_cnt_cache = diag_cnt_cache
  end,
})

---Get string representation of diagnostics for current buffer
---@return string
function _G._statusline.diag()
  if vim.b.diag_str_cache then
    return vim.b.diag_str_cache
  end
  local str = ''
  local buf_cnt = vim.b.diag_cnt_cache or {}
  for serverity_nr, severity in ipairs({ 'Error', 'Warn', 'Info', 'Hint' }) do
    local cnt = buf_cnt[serverity_nr] or 0
    if cnt > 0 then
      local icon_hl = 'StatusLineDiagnostic' .. severity
      str = str .. (str == '' and '' or ' ') .. utils.stl.hl(cnt, icon_hl)
    end
  end
  if str:find('%S') then
    str = str .. ' '
  end
  vim.b.diag_str_cache = str
  return str
end

vim.api.nvim_create_autocmd({ 'LspAttach', 'LspDetach' }, {
  group = groupid,
  desc = 'Update lsp cache for the status line.',
  callback = function(info)
    local b = vim.b[info.buf]
    local clients = vim.lsp.get_clients({ bufnr = info.buf })
    local names = {}
    vim.iter(clients):each(function(client)
      table.insert(names, client.name)
    end)
    b.lsp_str_cache = nil
    b.lsp_names_cache = names
  end,
})

---@return string
function _G._statusline.lsp()
  if vim.b.lsp_str_cache then
    return vim.b.lsp_str_cache
  end
  local str = ''
  local names = vim.b.lsp_names_cache or {}
  str = table.concat(names, ', ')
  if str:find('%S') then
    str = str .. ' '
  end
  vim.b.lsp_str_cache = str
  return str
end

-- stylua: ignore start
---Statusline components
---@type table<string, string>
local components = {
  align        = [[%=]],
  diag         = [[%{%v:lua.require'my.core._internal.statusline'.diag()%}]],
  lsp          = [[%{%v:lua.require'my.core._internal.statusline'.lsp()%}]],
  fname        = [[%{%v:lua.require'my.core._internal.statusline'.fname()%}]],
  info         = [[%{%v:lua.require'my.core._internal.statusline'.info()%}]],
  padding      = [[ ]],
  pos          = [[%{%&ru?"%l:%c ":""%}]],
  truncate     = [[%<]],
}
-- stylua: ignore end

local stl = table.concat({
  components.padding,
  components.fname,
  components.padding,
  components.info,
  components.align,
  components.truncate,
  components.lsp,
  components.diag,
  components.pos,
})

local stl_nc = table.concat({
  components.padding,
  components.fname,
  components.padding,
  components.info,
  components.align,
  components.truncate,
  components.lsp,
  components.diag,
  components.pos,
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

  ---@param hlgroup_name string
  ---@param attr table
  ---@return nil
  local function sethl(hlgroup_name, attr)
    local merged_attr = vim.tbl_deep_extend('keep', attr, default_attr)
    utils.hl.set_default(0, hlgroup_name, merged_attr)
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
