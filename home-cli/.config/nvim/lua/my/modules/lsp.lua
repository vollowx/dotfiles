return {
  {
    'Wansmer/symbol-usage.nvim',
    event = 'LspAttach',
    config = function()
      require('my.configs.symbol-usage')
    end,
  },
}
