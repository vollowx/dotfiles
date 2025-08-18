return {
  {
    'romainl/vim-cool',
    lazy = false,
  },

  {
    'tzachar/local-highlight.nvim',
    event = 'VeryLazy',
    config = function()
      require('configs.local-highlight')
    end,
  },

  {
    'mcauley-penney/visual-whitespace.nvim',
    event = 'ModeChanged *:[vV\22]',
    config = function()
      require('configs.visual-whitespace')
    end,
  },

  {
    'Aasim-A/scrollEOF.nvim',
    event = { 'CursorMoved', 'WinScrolled' },
    config = function()
      require('configs.scroll-eof')
    end,
  },

  {
    'https://github.com/folke/which-key.nvim',
    event = 'VeryLazy',
    config = function()
      require('configs.which-key')
    end,
  },
}
