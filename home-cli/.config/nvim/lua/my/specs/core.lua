return {
  {
    src = 'https://github.com/miikanissi/modus-themes.nvim',
    data = {
      postload = function()
        require('modus-themes').setup({
          line_nr_column_background = false,
          sign_column_background = false,
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
