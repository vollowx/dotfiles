return {
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
  { src = 'https://github.com/tpope/vim-surround' },
  { src = 'https://github.com/justinmk/vim-sneak' },
  { src = 'https://github.com/junegunn/vim-easy-align' },
}
