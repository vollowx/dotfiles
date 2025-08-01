return {
  {
    'saghen/blink.cmp',
    dependencies = {
      'rafamadriz/friendly-snippets',
      'xzbdmw/colorful-menu.nvim',
    },
    version = 'v1.*',
    event = 'InsertEnter',
    config = function()
      require('configs.blink-cmp')
    end,
  },
}
