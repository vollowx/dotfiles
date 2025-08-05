local icons = require('utils.icons')

vim.diagnostic.config({
  severity_sort = true,
  jump = { float = true },
  virtual_text = {
    spacing = 4,
    prefix = vim.trim(icons.ui.AngleLeft),
    severity = {
      max = vim.diagnostic.severity.WARN,
    },
  },
  virtual_lines = {
    severity = {
      min = vim.diagnostic.severity.ERROR,
    },
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
