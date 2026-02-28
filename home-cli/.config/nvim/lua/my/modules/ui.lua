return {
  {
    'romainl/vim-cool',
    lazy = false,
  },

  {
    'tzachar/local-highlight.nvim',
    event = 'VeryLazy',
    config = function()
      require('my.configs.local-highlight')
    end,
  },

  {
    'Aasim-A/scrollEOF.nvim',
    event = { 'CursorMoved', 'WinScrolled' },
    config = function()
      require('my.configs.scroll-eof')
    end,
  },

  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    config = function()
      require('my.configs.which-key')
    end,
  },
}
