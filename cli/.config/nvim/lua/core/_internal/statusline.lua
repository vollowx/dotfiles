local statusline = {}
local utils = require('utils')
local groupid = vim.api.nvim_create_augroup('StatusLine', {})

local diag_signs_default_text = { 'E', 'W', 'I', 'H' }

local diag_severity_map = {
  [1] = 'ERROR',
  [2] = 'WARN',
  [3] = 'INFO',
  [4] = 'HINT',
  ERROR = 1,
  WARN = 2,
  INFO = 3,
  HINT = 4,
}

---@param severity integer|string
---@return string
local function get_diag_sign_text(severity)
  local diag_config = vim.diagnostic.config()
  local signs_text = diag_config
    and diag_config.signs
    and type(diag_config.signs) == 'table'
    and diag_config.signs.text
  return signs_text
      and (signs_text[severity] or signs_text[diag_severity_map[severity]])
    or (
      diag_signs_default_text[severity]
      or diag_signs_default_text[diag_severity_map[severity]]
    )
end

---From `vim.lsp.status()`
---@return string
local function get_lsp_status()
  local messages = {} --- @type string[]
  for _, client in ipairs(vim.lsp.get_clients()) do
    --- @diagnostic disable-next-line:no-unknown
    for progress in client.progress do
      --- @cast progress {token: lsp.ProgressToken, value: lsp.LSPAny}
      local value = progress.value
      if type(value) == 'table' and value.kind then
        local message = value.message
            and (value.title .. ': ' .. value.message)
          or value.title
        messages[#messages + 1] = message
      end
      -- else: Doesn't look like work done progress and can be in any format
      -- Just ignore it as there is no sensible way to display it
    end
  end
  return table.concat(messages, ', ')
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
function statusline.mode()
  local hl = vim.bo.mod and 'StatusLineHeaderModified' or 'StatusLineHeader'
  local mode = vim.fn.mode()
  local mode_str = (mode == 'n' and (vim.bo.ro or not vim.bo.ma)) and 'RO'
    or modes[mode]
  return utils.stl.hl(string.format(' %s ', mode_str), hl) .. ' '
end

---Get file name
---@return string
function statusline.fname()
  local bname = '%t' -- TODO: Use Neovim API to get buffer name

  if vim.bo.filetype == 'oil' then
    bname = require('oil').get_current_dir()
  end

  if vim.bo.filetype == 'lazy' then
    bname = 'Packages'
  end

  if vim.bo.filetype == 'lspinfo' then
    bname = 'LSP Servers'
  end

  return bname
end

---Get diff stats for current buffer
---@return string
function statusline.gitdiff()
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
function statusline.branch()
  ---@diagnostic disable-next-line: undefined-field
  local branch = vim.b.gitsigns_status_dict and vim.b.gitsigns_status_dict.head
    or ''
  return branch == '' and '' or '#' .. branch
end

---Get current filetype
---@return string
function statusline.ft()
  return vim.bo.ft == '' and '' or vim.bo.ft:gsub('^%l', string.upper)
end

---Additional info for the current buffer enclosed in parentheses
---@return string
function statusline.info()
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
  add_section(statusline.branch())
  add_section(statusline.gitdiff())
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
function statusline.diag()
  if vim.b.diag_str_cache then
    return vim.b.diag_str_cache
  end
  local str = ''
  local buf_cnt = vim.b.diag_cnt_cache or {}
  for serverity_nr, severity in ipairs({ 'Error', 'Warn', 'Info', 'Hint' }) do
    local cnt = buf_cnt[serverity_nr] or 0
    if cnt > 0 then
      local icon_text = get_diag_sign_text(serverity_nr)
      local icon_hl = 'StatusLineDiagnostic' .. severity
      str = str
        .. (str == '' and '' or ' ')
        .. utils.stl.hl(icon_text, icon_hl)
        .. cnt
    end
  end
  if str:find('%S') then
    str = str .. ' '
  end
  vim.b.diag_str_cache = str
  return str
end

local spinner_end_keep = 2000 -- ms
local spinner_status_keep = 600 -- ms
local spinner_progress_keep = 80 -- ms
local spinner_timer = vim.uv.new_timer()

local spinner_icons ---@type string[]
local spinner_icon_done ---@type string

spinner_icon_done = vim.trim(icons.diagnostics.DiagnosticSignOk)
spinner_icons = {
  '⠋',
  '⠙',
  '⠹',
  '⠸',
  '⠼',
  '⠴',
  '⠦',
  '⠧',
  '⠇',
  '⠏',
}

---Id and additional info of language servers in progress
---@type table<integer, { name: string, timestamp: integer, type: 'begin'|'report'|'end' }>
local server_info = {}
---@type string
local server_last_status = ''

vim.api.nvim_create_autocmd('LspProgress', {
  desc = 'Update LSP progress info for the status line.',
  group = groupid,
  callback = function(info)
    if spinner_timer then
      spinner_timer:start(
        spinner_progress_keep,
        spinner_progress_keep,
        vim.schedule_wrap(vim.cmd.redrawstatus)
      )
    end

    local id = info.data.client_id
    local now = vim.uv.now()
    -- Update LSP progress data
    server_info[id] = {
      name = vim.lsp.get_client_by_id(id).name,
      timestamp = now,
      type = info.data
        and info.data.params
        and info.data.params.value
        and info.data.params.value.kind,
    }
    server_last_status = get_lsp_status()
    -- Clear client message after a short time if no new message is received
    vim.defer_fn(function()
      -- No new report since the timer was set
      local last_timestamp = (server_info[id] or {}).timestamp
      if not last_timestamp or last_timestamp == now then
        server_info[id] = nil
        if vim.tbl_isempty(server_info) and spinner_timer then
          spinner_timer:stop()
        end
        vim.cmd.redrawstatus()
      end
    end, spinner_end_keep)
  end,
})

---@return string
function statusline.lsp_progress()
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  if next(clients) == nil then
    return ''
  end

  local client_names = {}
  local excluded_clients = {
    copilot = true,
  }
  for _, client in pairs(clients) do
    if not excluded_clients[client.name] then
      table.insert(client_names, client.name)
    end
  end

  if vim.tbl_isempty(server_info) then
    return string.format('%s ', table.concat(client_names, ', '))
  end

  local buf = vim.api.nvim_get_current_buf()
  local server_ids = {}
  for id, _ in pairs(server_info) do
    if vim.tbl_contains(vim.lsp.get_buffers_by_client_id(id), buf) then
      table.insert(server_ids, id)
    end
  end
  if vim.tbl_isempty(server_ids) then
    return ''
  end

  local now = vim.uv.now()
  ---@return boolean
  local function allow_changing_state()
    return not vim.b.spinner_state_changed
      or now - vim.b.spinner_state_changed > spinner_status_keep
  end

  if #server_ids == 1 and server_info[server_ids[1]].type == 'end' then
    if vim.b.spinner_icon ~= spinner_icon_done and allow_changing_state() then
      vim.b.spinner_state_changed = now
      vim.b.spinner_icon = spinner_icon_done
    end
  else
    local spinner_icon_progress = spinner_icons[math.ceil(
      now / spinner_progress_keep
    ) % #spinner_icons + 1]
    if vim.b.spinner_icon ~= spinner_icon_done then
      vim.b.spinner_icon = spinner_icon_progress
    elseif allow_changing_state() then
      vim.b.spinner_state_changed = now
      vim.b.spinner_icon = spinner_icon_progress
    end
  end

  return string.format(
    '%s %s %s ',
    utils.stl.hl(server_last_status, 'StatusLineLspProgressMsg'),
    utils.stl.hl(vim.b.spinner_icon, 'StatusLineLspProgressIcon'),
    table.concat(client_names, ', ')
  )
end

-- TODO: Check if copilot.lua is available
-- TODO: Update with autocmd
local ca = require('copilot.api')
local cc = require('copilot.client')

local copilot = {}
copilot.is_enabled = function()
  return (not cc.is_disabled())
    and cc.buf_is_attached(vim.api.nvim_get_current_buf())
end
copilot.is_error = function()
  return (not cc.is_disabled())
    and cc.buf_is_attached(vim.api.nvim_get_current_buf())
    and ca.status.data.status == 'Warning'
end
copilot.is_loading = function()
  return (not cc.is_disabled())
    and cc.buf_is_attached(vim.api.nvim_get_current_buf())
    and ca.status.data.status == 'InProgress'
end

---@return string
function statusline.copilot()
  local icon = copilot.is_loading() and icons.ui.CircleDots
    or copilot.is_error() and icons.ui.Warning
    or copilot.is_enabled() and icons.ui.Copilot
    or icons.ui.CopilotError
  return string.format('%s ', icon)
end

-- stylua: ignore start
---Statusline components
---@type table<string, string>
local components = {
  align        = [[%=]],
  diag         = [[%{%v:lua.require'core._internal.statusline'.diag()%}]],
  fname        = [[%{%v:lua.require'core._internal.statusline'.fname()%}]],
  info         = [[%{%v:lua.require'core._internal.statusline'.info()%}]],
  lsp_progress = [[%{%v:lua.require'core._internal.statusline'.lsp_progress()%}]],
  mode         = [[%{%v:lua.require'core._internal.statusline'.mode()%}]],
  copilot      = [[%{%v:lua.require'core._internal.statusline'.copilot()%}]],
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
  components.lsp_progress,
  components.diag,
  components.copilot,
  components.pos,
})

local stl_nc = table.concat({
  components.padding,
  components.fname,
  components.align,
  components.truncate,
  components.pos,
})

---Get statusline string
---@return string
function statusline.get()
  return vim.g.statusline_winid == vim.api.nvim_get_current_win() and stl
    or stl_nc
end

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
  sethl('StatusLineGitAdded', { fg = 'GitSignsAdd' })
  sethl('StatusLineGitChanged', { fg = 'GitSignsChange' })
  sethl('StatusLineGitRemoved', { fg = 'GitSignsDelete' })
  sethl('StatusLineDiagnosticHint', { fg = 'DiagnosticSignHint' })
  sethl('StatusLineDiagnosticInfo', { fg = 'DiagnosticSignInfo' })
  sethl('StatusLineDiagnosticWarn', { fg = 'DiagnosticSignWarn' })
  sethl('StatusLineDiagnosticError', { fg = 'DiagnosticSignError' })
  sethl('StatusLineLspProgressMsg', { fg = 'NonText' })
  sethl('StatusLineLspProgressIcon', { fg = 'Constant' })
  sethl('StatusLineHeader', { fg = 'Keyword', bold = true })
  sethl('StatusLineHeaderModified', { fg = 'Function', bold = true })
end
set_default_hlgroups()

vim.api.nvim_create_autocmd('ColorScheme', {
  group = groupid,
  callback = set_default_hlgroups,
})

return statusline
