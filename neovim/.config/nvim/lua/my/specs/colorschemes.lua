return {
  {
    src = 'https://github.com/miikanissi/modus-themes.nvim',
    data = {
      postload = function()
        require('modus-themes').setup({
          line_nr_column_background = false,
          sign_column_background = false,
          styles = { comments = { italic = false }, keywords = { italic = false } },
          on_highlights = function(highlight, color)
            highlight['WinBarNC'] = { link = 'TabLineSel' }

            -- stylua: ignore start
            highlight['CompileModeError']         = { fg = color.error }
            highlight['CompileModeInfo']          = { fg = color.info }
            highlight['CompileModeWarning']       = { fg = color.warning }
            highlight['CompileModeCommandOutput'] = { fg = color.blue_faint }
            highlight['CompileModeMessageRow']    = { fg = color.magenta, bold = true }
            highlight['CompileModeMessageCol']    = { fg = color.cyan, bold = true }

            highlight['@org.headline.level1']          = { fg = color.magenta_cooler }
            highlight['@org.headline.level2']          = { fg = color.magenta_warmer }
            highlight['@org.headline.level3']          = { fg = color.blue }
            highlight['@org.headline.level4']          = { fg = color.cyan }
            highlight['@org.headline.level5']          = { fg = color.green_warmer }
            highlight['@org.headline.level6']          = { fg = color.yellow }
            highlight['@org.headline.level7']          = { fg = color.red }
            highlight['@org.headline.level8']          = { fg = color.magenta }
            highlight['@org.keyword.todo']             = { fg = color.red }
            highlight['@org.keyword.done']             = { fg = color.green }
            highlight['@org.drawer']                   = { fg = color.magenta }
            highlight['@org.agenda.header']            = { fg = color.blue_faint, bold = true }
            highlight['@org.agenda.deadline']          = { fg = color.red_cooler }
            highlight['@org.agenda.deadline.upcoming'] = { fg = color.red_faint }
            highlight['@org.agenda.scheduled']         = { fg = color.yellow_faint }
            highlight['@org.agenda.scheduled_past']    = { fg = color.yellow_faint }
            highlight['@org.agenda.time_grid']         = { fg = color.fg_dim }
            highlight['@org.agenda.day']               = { fg = color.cyan, bold = true }
            highlight['@org.agenda.today']             = { fg = color.cyan, bold = true,    underline = true }
            highlight['@org.agenda.weekend']           = { fg = color.magenta, bold = true }
            highlight['@org.agenda.weekend.today']     = { fg = color.magenta, bold = true, underline = true }
            -- stylua: ignore end
          end,
        })
      end,
    },
  },
  {
    src = 'https://github.com/sainnhe/everforest',
    data = { on = 'CursorHold' },
  },
  {
    src = 'https://github.com/catppuccin/nvim',
    name = 'catppuccin',
    data = { on = 'CursorHold' },
  },
}
