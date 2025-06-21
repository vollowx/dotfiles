return {
  { 'nvim-lua/plenary.nvim' },

  {
    'rachartier/tiny-devicons-auto-colors.nvim',
    dependencies = 'vollowx/nvim-web-devicons',
    event = 'VeryLazy',
    config = load_pkg('devicons-auto-colors'),
  },

  { 'nvzone/volt' },
}
