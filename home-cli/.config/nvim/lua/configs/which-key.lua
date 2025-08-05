local icons = require('utils.icons')

local wk = require('which-key')
wk.setup({
  preset = 'helix',
  delay = function(ctx)
    return ctx.plugin and 0 or 640
  end,
  win = { border = 'single' },
  show_help = false,
  sort = {
    'local',
    'order',
    'group',
    'desc',
    'alphanum',
    'mod',
  },
  filter = function(mapping)
    return not mapping.lhs:find('<Esc>', 0, true)
      and not mapping.lhs:find('<.*Mouse.*>')
      and not mapping.lhs:find('<.*ScrollWheel.*>')
  end,
  defer = function(ctx)
    return ctx.mode == 'V' or ctx.mode == '<C-V>' or ctx.mode == 'v'
  end,
  plugins = {
    marks = false,
    registers = false,
    spelling = {
      enabled = false,
    },
  },
  icons = {
    mappings = false,
    breadcrumb = '',
    separator = '',
    group = '+',
    ellipsis = icons.ui.Ellipsis,
    keys = {
      Up = '<Up>',
      Down = '<Down>',
      Left = '<Left>',
      Right = '<Right>',
      C = '<Control>',
      M = '<Meta>',
      D = '<Command>',
      S = '<Shift>',
      CR = '<Enter>',
      Esc = '<Esc>',
      ScrollWheelDown = '<MouseDown>',
      ScrollWheelUp = '<MouseUp>',
      NL = '<Enter>',
      BS = '<BS>',
      Space = '<Space>',
      Tab = '<Tab>',
      F1 = '<F1>',
      F2 = '<F2>',
      F3 = '<F3>',
      F4 = '<F4>',
      F5 = '<F5>',
      F6 = '<F6>',
      F7 = '<F7>',
      F8 = '<F8>',
      F9 = '<F9>',
      F10 = '<F10>',
      F11 = '<F11>',
      F12 = '<F12>',
    },
  },
})

wk.add({
  { '<Leader>g', group = 'Git' },
  { '<Leader>f', group = 'Find' },
  { '<Leader>fg', group = 'Git' },
  { '<Leader>gf', group = 'Find' },
  { '<Leader>fS', group = 'LSP' },
})

---Set default highlight groups for which-key.nvim
---@return nil
local function set_default_hlgroups()
  -- Ensure visibility in tty
  if not vim.go.termguicolors then
    vim.api.nvim_set_hl(0, 'WhichKey', { link = 'Normal', default = true })
    vim.api.nvim_set_hl(0, 'WhichKeyDesc', { link = 'Normal', default = true })
    vim.api.nvim_set_hl(
      0,
      'WhichKeySeparator',
      { link = 'WhichKeyGroup', default = true }
    )
  end
end

set_default_hlgroups()
vim.api.nvim_create_autocmd('ColorScheme', {
  group = vim.api.nvim_create_augroup('WhichKeySetDefaultHlgroups', {}),
  desc = 'Set default highlight groups for which-key.nvim.',
  callback = set_default_hlgroups,
})

vim.api.nvim_create_autocmd('ModeChanged', {
  desc = 'Redraw statusline shortly after mode change to ensure correct mode display after enting visual mode when which-key.nvim is enabled.',
  group = vim.api.nvim_create_augroup('WhichKeyRedrawStatusline', {}),
  callback = vim.schedule_wrap(function()
    vim.cmd.redrawstatus({
      mods = { emsg_silent = true },
    })
  end),
})
