return {
  {
    src = 'https://github.com/stevearc/quicker.nvim',
    data = {
      after = function(_)
        local icons = require('my.utils.icons')

        require('quicker').setup({
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
          borders = {
            vert = ' ',
            strong_header = '-',
            strong_cross = '-',
            strong_end = '-',
            soft_header = '-',
            soft_cross = '-',
            soft_end = '-',
          },
          max_filename_width = function()
            return math.max(32, math.ceil(vim.go.columns / 4))
          end,
          keys = {
            {
              '>',
              function()
                require('quicker').expand({
                  before = 2,
                  after = 2,
                  add_to_existing = true,
                })
              end,
              desc = 'Expand quickfix context',
            },
            {
              '<',
              function()
                require('quicker').collapse()
              end,
              desc = 'Collapse quickfix context',
            },
          },
        })
      end,
    },
  },
}
