---@diagnostic disable-next-line: duplicate-set-field
vim.validate = function() end
vim.loader.enable()

vim.g.has_ui = #vim.api.nvim_list_uis() > 0
vim.g.has_gui = vim.g.has_ui
  and (
    vim.env.DISPLAY ~= nil
    or vim.env.WAYLAND_DISPLAY ~= nil
    or vim.env.WSL_DISTRO_NAME ~= nil
  )

require('my')

if vim.g.has_gui and vim.g.has_ui then
  vim.cmd.colorscheme('wildcharm')
end
