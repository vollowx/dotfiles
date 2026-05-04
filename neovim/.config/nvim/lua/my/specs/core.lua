return {
  { src = 'https://github.com/nvim-lua/plenary.nvim' },

  -- NOTE: `*:c` catches commands and search
  {
    src = 'https://github.com/romainl/vim-cool',
    data = { on = 'ModeChanged', pattern = '*:c' },
  },
  {
    src = 'https://github.com/tpope/vim-sleuth',
    data = { on = { 'BufReadPre', 'BufNewFile' } },
  },
  { src = 'https://github.com/tpope/vim-fugitive' },
  { src = 'https://github.com/wakatime/vim-wakatime' },
}
