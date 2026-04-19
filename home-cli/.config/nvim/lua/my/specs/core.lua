return {
  {
    src = 'https://github.com/miikanissi/modus-themes.nvim',
    data = {
      postload = function()
        require('modus-themes').setup({
          line_nr_column_background = false,
          sign_column_background = false,
          on_highlights = function(highlight, color)
            highlight['@org.headline.level1']       = { fg = color.magenta_cooler }
            highlight['@org.headline.level2']       = { fg = color.magenta_warmer }
            highlight['@org.headline.level3']       = { fg = color.blue }
            highlight['@org.headline.level4']       = { fg = color.cyan }
            highlight['@org.headline.level5']       = { fg = color.green_warmer }
            highlight['@org.headline.level6']       = { fg = color.yellow }
            highlight['@org.headline.level7']       = { fg = color.red }
            highlight['@org.headline.level8']       = { fg = color.magenta }
            highlight['@org.keyword.todo']          = { fg = color.green }
            highlight['@org.keyword.done']          = { fg = color.red }
            highlight['@org.drawer']                = { fg = color.magenta }
            highlight['@org.agenda.deadline']       = { fg = color.magenta }
            highlight['@org.agenda.scheduled']      = { fg = color.yellow }
            highlight['@org.agenda.scheduled_past'] = { fg = color.yellow_faint }
            highlight['@org.agenda.time_grid']      = { fg = color.fg_dim }
            highlight['@org.agenda.day']            = { fg = color.cyan }
            highlight['@org.agenda.today']          = { fg = color.magenta, underline = true }
            highlight['@org.agenda.weekend']        = { fg = color.magenta }
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

  -- NOTE: `*:c` catches commands and search
  {
    src = 'https://github.com/romainl/vim-cool',
    data = { on = 'ModeChanged', pattern = '*:c' },
  },
  { src = 'https://github.com/rhysd/clever-f.vim' },
  {
    src = 'https://github.com/tpope/vim-sleuth',
    data = { on = { 'BufReadPre', 'BufNewFile' } },
  },
  { src = 'https://github.com/tpope/vim-fugitive' },
  { src = 'https://github.com/wakatime/vim-wakatime' },
  { src = 'https://github.com/junegunn/vim-easy-align' },
}
