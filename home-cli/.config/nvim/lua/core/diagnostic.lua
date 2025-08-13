local icons = require('utils.icons')

vim.diagnostic.config({
  severity_sort = true,
  jump = { float = true },
  virtual_text = {
    spacing = 4,
    prefix = '',
    format = function(diag)
      local clean_src_names = {
        ['Lua Diagnostics.'] = 'lua',
        ['Lua Syntax Check.'] = 'lua',
      }

      local msg
      if not diag.code then
        return ' '
      end

      msg = diag.message

      if diag.source then
        msg = string.format(
          '%s [%s] ',
          msg,
          clean_src_names[diag.source] or diag.source
        )
      end

      return msg
    end,
  },
  float = {
    header = '',
    source = 'if_many',
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
