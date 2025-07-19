return {
  {
    'romainl/vim-cool',
    lazy = false,
  },

  {
    'brenoprata10/nvim-highlight-colors',
    enabled = vim.g.has_gui,
    event = 'VeryLazy',
    config = load_plugin('highlight-colors'),
  },

  {
    'tzachar/local-highlight.nvim',
    event = 'VeryLazy',
    config = load_plugin('local-highlight'),
  },

  {
    'Aasim-A/scrollEOF.nvim',
    event = { 'CursorMoved', 'WinScrolled' },
    config = load_plugin('scroll-eof'),
  },
}
