return {
  { 'sainnhe/everforest' },
  {
    'uncenter/ctp-nvim',
    branch = 'patch-1',
    name = 'catppuccin',
    config = function()
      require('configs.catppuccin')
    end,
  },
}
