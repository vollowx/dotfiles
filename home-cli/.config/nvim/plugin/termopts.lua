vim.api.nvim_create_autocmd({ 'TermOpen' }, {
  group = vim.api.nvim_create_augroup('TermOpts', {}),
  desc = 'Set terminal settings.',
  callback = function(info)
    require('my.plugins.termopts').setup(info.buf)
  end,
})
