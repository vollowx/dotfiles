local load_colors = function()
  return require('catppuccin.palettes').get_palette()
end

require('tiny-devicons-auto-colors').setup({ colors = load_colors() })

vim.api.nvim_create_augroup('Devicons', { clear = true })
vim.api.nvim_create_autocmd('colorscheme', {
  callback = function()
    require('tiny-devicons-auto-colors').apply(load_colors())
  end,
  group = 'Devicons',
})
