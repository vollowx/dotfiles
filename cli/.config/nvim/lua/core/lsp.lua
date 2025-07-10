vim.lsp.enable({ 'clangd', 'qmlls', 'lua_ls' })

local lsp_settings =
  vim.api.nvim_create_augroup('LspSettings', { clear = true })
vim.api.nvim_create_autocmd('LspAttach', {
  group = lsp_settings,
  once = true,
  callback = function()
    require('core._internal.lsp').setup()
  end,
})
-- vim.api.nvim_create_autocmd('LspAttach', {
--   group = lsp_settings,
--   callback = function(info)
--     vim.lsp.inlay_hint.enable(true, { bufnr = info.buf })
--   end,
-- })
