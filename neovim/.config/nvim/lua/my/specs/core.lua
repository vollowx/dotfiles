return {
  { src = 'https://github.com/neovim/nvim-lspconfig' },

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
