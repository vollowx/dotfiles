local utils = {
  fs = require('my.utils.fs'),
  hl = require('my.utils.hl'),
  stl = require('my.utils.stl'),
}
local groupid = vim.api.nvim_create_augroup('StatusLine', {})

_G._statusline = {}

---@param len integer
---@param text string
---@return string
local function make_segment(len, text)
  local ok, status_info =
    pcall(vim.api.nvim_eval_statusline, text, { winid = 0 })
  local visual_width = ok and status_info.width or 0

  local padding_len = math.max(0, len - visual_width)

  return text .. string.rep(' ', padding_len) .. '   '
end

-- stylua: ignore start
local modes = {
  ['n']      = 'NO',
  ['no']     = 'OP',
  ['nov']    = 'OC',
  ['noV']    = 'OL',
  ['no\x16'] = 'OB',
  ['\x16']   = 'VB',
  ['niI']    = 'IN',
  ['niR']    = 'RE',
  ['niV']    = 'RV',
  ['nt']     = 'NT',
  ['ntT']    = 'TM',
  ['v']      = 'VI',
  ['vs']     = 'VI',
  ['V']      = 'VL',
  ['Vs']     = 'VL',
  ['\x16s']  = 'VB',
  ['s']      = 'SE',
  ['S']      = 'SL',
  ['\x13']   = 'SB',
  ['i']      = 'IN',
  ['ic']     = 'IC',
  ['ix']     = 'IX',
  ['R']      = 'RE',
  ['Rc']     = 'RC',
  ['Rx']     = 'RX',
  ['Rv']     = 'RV',
  ['Rvc']    = 'RC',
  ['Rvx']    = 'RX',
  ['c']      = 'CO',
  ['cv']     = 'CV',
  ['r']      = 'PR',
  ['rm']     = 'PM',
  ['r?']     = 'P?',
  ['!']      = 'SH',
  ['t']      = 'TE',
}
-- stylua: ignore end

---Get string representation of the current mode
---@return string
function _G._statusline.mode()
  return string.format('<%s>   ', modes[vim.fn.mode()])
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

  return make_segment(16, str)
end

---Get Emacs-like state block
---@return string
function _G._statusline.state()
  local fenc = (vim.bo.fenc ~= '' and vim.bo.fenc or vim.o.enc):upper()
  local encoding_part = fenc:sub(1, 1) -- i.e. 'U' for UTF-8

  local ff = vim.bo.fileformat
  local format_part = ff == 'unix' and ':'
    or (ff == 'dos' and '\\' or '/')

  local rw_part = (vim.bo.readonly or not vim.bo.ma) and '%%%%'
    or vim.bo.modified and '**'
    or '--'

  local is_remote = false -- TODO: To be implemented
  local remote_part = is_remote and '@' or '-'

  -- Example look: U:---
  local state_str =
    string.format('%s%s%s%s', encoding_part, format_part, rw_part, remote_part)

  return string.format('%s  ', state_str)
end

---Get file name
---@return string
function _G._statusline.fname()
  local function get_bare_fname()
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

    return utils.stl.escape(display_name)
  end

  return make_segment(16, get_bare_fname())
end

---Get diff stats for current buffer
---@param nc boolean
---@return string
function _G._statusline.gitdiff(nc)
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
      str = str .. (str == '' and '' or ' ') .. utils.stl.hl(tostring(cnt), hl)
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
  return make_segment(
    24,
    vim.tbl_isempty(info) and '(Nop)'
      or string.format('(%s)', table.concat(info, ' '))
  )
end

-- stylua: ignore start
---Statusline components
---@type table<string, string>
local components = {
  mode         = [[%{%v:lua.require'my.plugins.eline'.mode()%}]],
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
  components.mode,
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
  components.mode,
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
