vim.api.nvim_create_autocmd({ 'UIEnter' }, {
  group = vim.api.nvim_create_augroup('TmuxCoop', {}),
  desc = 'Load tmux support.',
  callback = function()
    require('my.plugins.tmuxcoop').setup()
  end,
})
