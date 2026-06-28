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
  {
    src = 'https://github.com/gbprod/substitute.nvim',
    data = {
      postload = function(_)
        require('substitute').setup({})
        vim.keymap.set('n', 's', require('substitute').operator, { noremap = true })
        vim.keymap.set('n', 'ss', require('substitute').line, { noremap = true })
        vim.keymap.set('n', 'S', require('substitute').eol, { noremap = true })
        vim.keymap.set('x', 's', require('substitute').visual, { noremap = true })
      end,
    },
  },
  { src = 'https://github.com/tpope/vim-surround' },
  { src = 'https://github.com/junegunn/vim-easy-align' },
}
