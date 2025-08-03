return {
  {
    'saghen/blink.cmp',
    dependencies = {
      'rafamadriz/friendly-snippets',
      'xzbdmw/colorful-menu.nvim',
    },
    version = 'v1.*',
    event = { 'InsertEnter', 'CmdlineEnter' },
    config = function()
      require('configs.blink-cmp')
    end,
  },
}
