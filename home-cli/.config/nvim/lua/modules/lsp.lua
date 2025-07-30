return {
  {
    'Wansmer/symbol-usage.nvim',
    event = 'LspAttach',
    config = load_plugin('symbol-usage'),
  },

  -- TODO: Configure this in jsonls
  { 'b0o/schemastore.nvim' },
}
