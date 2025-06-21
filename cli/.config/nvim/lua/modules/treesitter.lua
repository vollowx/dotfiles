return {
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    event = { 'BufRead', 'BufNewFile', 'VeryLazy' },
    config = load_pkg('treesitter', true),
    dependencies = {
      'RRethy/nvim-treesitter-endwise',
      'windwp/nvim-ts-autotag',
      {
        'nvim-treesitter/nvim-treesitter-context',
        opts = {
          max_lines = 3,
          zindex = 50,
        },
      },
    },
  },

  {
    'Wansmer/treesj',
    keys = {
      {
        'J',
        function()
          require('treesj').toggle()
        end,
      },
    },
  },

  {
    'Eandrju/cellular-automaton.nvim',
    cmd = 'CellularAutomaton',
  },
}
