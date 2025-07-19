if not vim.g.neovide then
  return
end

vim.o.guifont = 'monospace:h12'
vim.g.neovide_padding_top = 16
vim.g.neovide_padding_bottom = 16
vim.g.neovide_padding_right = 16
vim.g.neovide_padding_left = 16
vim.g.neovide_floating_shadow = false
vim.g.neovide_scale_factor = 1.0

local change_scale_factor = function(delta)
  vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * delta
end
vim.keymap.set('n', '<C-=>', function()
  change_scale_factor(1.25)
end)
vim.keymap.set('n', '<C-->', function()
  change_scale_factor(1 / 1.25)
end)
