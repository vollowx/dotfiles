local icons = require('my.utils.icons')

vim.diagnostic.config({
  severity_sort = true,
  jump = { float = true },
  float = { source = true },
  virtual_text = {
    spacing = 4,
    prefix = '',
  },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = icons.diagnostics.DiagnosticSignError,
      [vim.diagnostic.severity.WARN] = icons.diagnostics.DiagnosticSignWarn,
      [vim.diagnostic.severity.INFO] = icons.diagnostics.DiagnosticSignInfo,
      [vim.diagnostic.severity.HINT] = icons.diagnostics.DiagnosticSignHint,
    },
    numhl = {
      [vim.diagnostic.severity.ERROR] = 'DiagnosticSignError',
      [vim.diagnostic.severity.WARN] = 'DiagnosticSignWarn',
      [vim.diagnostic.severity.INFO] = 'DiagnosticSignInfo',
      [vim.diagnostic.severity.HINT] = 'DiagnosticSignHint',
    },
  },
})

-- stylua: ignore start
vim.keymap.set({ 'n', 'x' }, '<Leader>d', function() vim.diagnostic.setloclist() end, { desc = 'Show document diagnostics' })
vim.keymap.set({ 'n', 'x' }, '<Leader>D', function() vim.diagnostic.setqflist() end, { desc = 'Show workspace diagnostics' })
-- stylua: ignore end

---Open diagnostic floating window, jump to existing window if possible
local function diagnostic_open_float()
  ---@param win integer
  ---@return boolean
  local function is_diag_win(win)
    if vim.fn.win_gettype(win) ~= 'popup' then
      return false
    end
    local buf = vim.api.nvim_win_get_buf(win)
    return vim.bo[buf].bt == 'nofile'
      and unpack(vim.api.nvim_buf_get_lines(buf, 0, 1, false))
        == 'Diagnostics:'
  end

  -- If a diagnostic float window is already open, switch to it
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    if is_diag_win(win) then
      vim.api.nvim_set_current_win(win)
      return
    end
  end

  -- Else open diagnostic float
  vim.diagnostic.open_float()
end

-- stylua: ignore start
-- nvim's default mapping
vim.keymap.set({ 'n', 'x' }, '<M-d>', diagnostic_open_float, { desc = 'Open diagnostic floating window' })
vim.keymap.set({ 'n', 'x' }, '<C-w>d', diagnostic_open_float, { desc = 'Open diagnostic floating window' })
vim.keymap.set({ 'n', 'x' }, '<C-w><C-d>', diagnostic_open_float, { desc = 'Open diagnostic floating window' })
vim.keymap.set({ 'n', 'x' }, '<Leader>i', diagnostic_open_float, { desc = 'Open diagnostic floating window' })
-- stylua: ignore end

vim.keymap.set('n', 'yd', function()
  local diags = vim.diagnostic.get(0, { lnum = vim.fn.line('.') - 1 })
  local n_diags = #diags
  if n_diags == 0 then
    vim.notify('No diagnostics found in current line', vim.log.levels.WARN)
    return
  end

  ---@param msg string?
  local function yank(msg)
    if not msg then
      return
    end
    vim.fn.setreg('"', msg)
    vim.fn.setreg(vim.v.register, msg)
    vim.notify(
      string.format("Yanked diagnostic message '%s'", msg),
      vim.log.levels.INFO
    )
  end

  if n_diags == 1 then
    local msg = diags[1].message
    yank(msg)
    return
  end

  vim.ui.select(
    vim.tbl_map(function(d)
      return d.message
    end, diags),
    { prompt = 'Select diagnostic message to yank: ' },
    yank
  )
end, { desc = 'Yank diagnostic message on current line' })

-- stylua: ignore start
vim.keymap.set({ 'n', 'x' }, '[d', function() vim.diagnostic.jump({ count = -vim.v.count1 }) end, { desc = 'Go to previous diagnostic' })
vim.keymap.set({ 'n', 'x' }, ']d', function() vim.diagnostic.jump({ count =  vim.v.count1 }) end, { desc = 'Go to next diagnostic' })
vim.keymap.set({ 'n', 'x' }, '[e', function() vim.diagnostic.jump({ count = -vim.v.count1, severity = vim.diagnostic.severity.ERROR }) end, { desc = 'Go to previous diagnostic error' })
vim.keymap.set({ 'n', 'x' }, ']e', function() vim.diagnostic.jump({ count =  vim.v.count1, severity = vim.diagnostic.severity.ERROR }) end, { desc = 'Go to next diagnostic error' })
vim.keymap.set({ 'n', 'x' }, '[w', function() vim.diagnostic.jump({ count = -vim.v.count1, severity = vim.diagnostic.severity.WARN }) end, { desc = 'Go to previous diagnostic warning' })
vim.keymap.set({ 'n', 'x' }, ']w', function() vim.diagnostic.jump({ count =  vim.v.count1, severity = vim.diagnostic.severity.WARN }) end, { desc = 'Go to next diagnostic warning' })
vim.keymap.set({ 'n', 'x' }, '[i', function() vim.diagnostic.jump({ count = -vim.v.count1, severity = vim.diagnostic.severity.INFO }) end, { desc = 'Go to previous diagnostic info' })
vim.keymap.set({ 'n', 'x' }, ']i', function() vim.diagnostic.jump({ count =  vim.v.count1, severity = vim.diagnostic.severity.INFO }) end, { desc = 'Go to next diagnostic info' })
vim.keymap.set({ 'n', 'x' }, '[h', function() vim.diagnostic.jump({ count = -vim.v.count1, severity = vim.diagnostic.severity.HINT }) end, { desc = 'Go to previous diagnostic hint' })
vim.keymap.set({ 'n', 'x' }, ']h', function() vim.diagnostic.jump({ count =  vim.v.count1, severity = vim.diagnostic.severity.HINT }) end, { desc = 'Go to next diagnostic hint' })
-- stylua: ignore end
