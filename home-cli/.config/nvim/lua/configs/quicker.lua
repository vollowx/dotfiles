local icons = require('utils.icons')
local quicker = require('quicker')

quicker.setup({
  use_default_opts = false,
  opts = { signcolumn = 'auto' },
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
  borders = {
    vert = '│',
    -- Strong headers separate results from different files
    strong_header = '─',
    strong_cross = '┼',
    strong_end = '┤',
    -- Soft headers separate results within the same file
    soft_header = '─',
    soft_cross = '┼',
    soft_end = '┤',
  },
  max_filename_width = function()
    return math.max(32, math.ceil(vim.go.columns / 4))
  end,
})
