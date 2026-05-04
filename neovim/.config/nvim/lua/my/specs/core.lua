return {
  { src = 'https://github.com/nvim-lua/plenary.nvim' },

  { src = 'https://github.com/neovim/nvim-lspconfig' },

  {
    src = 'https://github.com/chrisgrieser/nvim-spider',
    data = {
      postload = function(_)
        -- stylua: ignore start
        vim.keymap.set({ 'n', 'o', 'x' }, 'w',  '<cmd>lua require("spider").motion("w")<CR>')
        vim.keymap.set({ 'n', 'o', 'x' }, 'e',  '<cmd>lua require("spider").motion("e")<CR>')
        vim.keymap.set({ 'n', 'o', 'x' }, 'b',  '<cmd>lua require("spider").motion("b")<CR>')
        vim.keymap.set({ 'n', 'o', 'x' }, 'ge', '<cmd>lua require("spider").motion("ge")<CR>')
        -- stylua: ignore end
      end,
    },
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
