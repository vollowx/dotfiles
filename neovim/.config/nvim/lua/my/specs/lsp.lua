return {
  { src = 'https://github.com/neovim/nvim-lspconfig' },

  {
    src = 'https://github.com/Wansmer/symbol-usage.nvim',
    data = {
      on = 'LspAttach',
      postload = function(_)
        require('symbol-usage').setup({ vt_position = 'end_of_line' })
      end,
    },
  },
}
