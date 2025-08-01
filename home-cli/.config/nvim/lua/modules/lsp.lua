return {
  {
    'Wansmer/symbol-usage.nvim',
    event = 'LspAttach',
    config = function ()
      require('configs.symbol-usage')
    end
  },

  -- TODO: Configure this in jsonls
  { 'b0o/schemastore.nvim' },
}
