local icons = require('utils.icons')
local quicker = require('quicker')

quicker.setup({
  use_default_opts = false,
  opts = { signcolumn = 'auto' },
  edit = { enabled = true },
  highlight = {
    lsp = false,
    treesitter = true,
    load_buffers = false,
  },
  type_icons = {
    E = icons.diagnostics.DiagnosticSignError,
    W = icons.diagnostics.DiagnosticSignWarn,
    I = icons.diagnostics.DiagnosticSignInfo,
    N = icons.diagnostics.DiagnosticSignHint,
    H = icons.diagnostics.DiagnosticSignHint,
  },
  max_filename_width = function()
    return math.max(32, math.ceil(vim.go.columns / 4))
  end,
})
