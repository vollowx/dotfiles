return {
  {
    'catppuccin/nvim',
    branch = 'feat/pmenu/vscode-style',
    name = 'catppuccin',
    config = function()
      require('configs.catppuccin')
    end,
  },
}
