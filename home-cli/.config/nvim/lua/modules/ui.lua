return {
  {
    'romainl/vim-cool',
    lazy = false,
  },

  {
    'brenoprata10/nvim-highlight-colors',
    enabled = vim.g.has_gui,
    event = 'VeryLazy',
    config = function()
      require('configs.highlight-colors')
    end,
  },

  {
    'tzachar/local-highlight.nvim',
    event = 'VeryLazy',
    config = function()
      require('configs.local-highlight')
    end,
  },

  {
    'Aasim-A/scrollEOF.nvim',
    event = { 'CursorMoved', 'WinScrolled' },
    config = function()
      require('configs.scroll-eof')
    end,
  },
}
