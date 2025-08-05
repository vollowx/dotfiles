local icons = require('utils.icons')
local utils = require('utils')
local groupid = vim.api.nvim_create_augroup('StatusLine', {})

_G._statusline = {}

-- Maximum widths
local gitbranch_max_width = 0.3 -- maximum width of git branch name

---Shorten string to a percentage of statusline width
---@param str string
---@param percent number
---@param str_alt? string alternate string to use when `str` exceeds max width
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
  local hl = vim.bo.mod and 'StatusLineHeaderModified' or 'StatusLineHeader'
  local mode = vim.fn.mode()
  local mode_str = (mode == 'n' and (vim.bo.ro or not vim.bo.ma)) and 'RO'
    or modes[mode]
  return utils.stl.hl(string.format(' %s ', mode_str), hl) .. ' '
end

---Get file name
---@return string
function _G._statusline.fname()
  local bname = '%t' -- TODO: Use Neovim API to get buffer name

  if vim.bo.filetype == 'oil' then
    bname = require('oil').get_current_dir() or 'Oil'
  end

  return bname
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
  return vim.bo.ft == '' and '' or vim.bo.ft:gsub('^%l', string.upper)
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
    or string.format(' (%s) ', table.concat(info, ', '))
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

---Id and additional info about LSP clients
---@type table<integer, { name: string, bufs: integer[] }>
local client_info = {}

vim.api.nvim_create_autocmd('LspDetach', {
  desc = 'Clean up server info when client detaches.',
  group = groupid,
  callback = function(args)
    if args.data.client_id then
      client_info[args.data.client_id] = nil
    end
  end,
})

vim.api.nvim_create_autocmd('LspProgress', {
  desc = 'Update LSP progress args for the status line.',
  group = groupid,
  callback = function(args)
    -- Update LSP progress data
    local id = args.data.client_id
    local bufs = vim.lsp.get_buffers_by_client_id(id)
    client_info[id] = {
      name = vim.lsp.get_client_by_id(id).name,
      bufs = bufs,
    }

    vim
      .iter(bufs)
      :filter(function(buf)
        -- No need to create and attach spinners to invisible bufs
        return vim.fn.bufwinid(buf) ~= -1
      end)
      :each(function(buf)
        local b = vim.b[buf]
        if not utils.stl.spinner.id_is_valid(b.spinner_id) then
          utils.stl.spinner:new():attach(buf)
        end

        local spinner = utils.stl.spinner.get_by_id(b.spinner_id)
        if spinner.status == 'idle' then
          spinner:spin()
        end

        local type = args.data
          and args.data.params
          and args.data.params.value
          and args.data.params.value.kind
        if type == 'end' then
          spinner:finish()
        end
      end)
  end,
})

---@return string
function _G._statusline.spinner()
  local spinner = utils.stl.spinner.get_by_id(vim.b.spinner_id)
  if not spinner or spinner.icon == '' then
    return ''
  end

  local buf = vim.api.nvim_get_current_buf()
  local progs = vim
    .iter(vim.tbl_keys(client_info))
    :filter(function(id)
      return vim.tbl_contains(client_info[id].bufs, buf)
    end)
    :map(function(id)
      return client_info[id].name
    end)
    :totable()

  -- Extra progresses requiring spinner animation
  if vim.b.spinner_progs then
    vim.list_extend(progs, vim.b.spinner_progs)
  end

  if vim.tbl_isempty(progs) then
    return ''
  end

  return string.format('%s %s ', table.concat(progs, ', '), spinner.icon)
end

-- stylua: ignore start
---Statusline components
---@type table<string, string>
local components = {
  align        = [[%=]],
  diag         = [[%{%v:lua.require'core._internal.statusline'.diag()%}]],
  fname        = [[%{%v:lua.require'core._internal.statusline'.fname()%}]],
  info         = [[%{%v:lua.require'core._internal.statusline'.info()%}]],
  spinner      = [[%{%v:lua.require'core._internal.statusline'.spinner()%}]],
  mode         = [[%{%v:lua.require'core._internal.statusline'.mode()%}]],
  padding      = [[ ]],
  pos          = [[%{%&ru?"%l:%c ":""%}]],
  truncate     = [[%<]],
}
-- stylua: ignore end

local stl = table.concat({
  components.mode,
  components.fname,
  components.info,
  components.align,
  components.truncate,
  components.spinner,
  components.diag,
  components.pos,
})

local stl_nc = table.concat({
  components.padding,
  components.fname,
  components.align,
  components.truncate,
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

vim.api.nvim_create_autocmd(
  { 'FileChangedShellPost', 'DiagnosticChanged', 'LspProgress' },
  {
    group = groupid,
    command = 'redrawstatus',
  }
)

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
  sethl('StatusLineHeader', { fg = 'Function', bg = 'TabLine' })
  sethl('StatusLineHeaderModified', { fg = 'Keyword', bg = 'TabLine' })
  -- stylua: ignore end
end
set_default_hlgroups()

vim.api.nvim_create_autocmd('ColorScheme', {
  group = groupid,
  callback = set_default_hlgroups,
})

return _G._statusline
