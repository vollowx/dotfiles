return {
  {
    'Wansmer/symbol-usage.nvim',
    event = 'LspAttach',
    config = function()
      require('configs.symbol-usage')
    end,
  },
}
