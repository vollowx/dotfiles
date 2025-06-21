return {
  {
    'Wansmer/symbol-usage.nvim',
    event = 'LspAttach',
    config = load_pkg('symbol-usage'),
  },

  -- TODO: Configure this in jsonls
  { 'b0o/schemastore.nvim' },

  {
    'neovim/nvim-lspconfig',
    event = { 'FileType', 'VeryLazy' },
    opts = { servers = settings.lsp_servers },
    config = function(_, opts)
      local lspconfig = require('lspconfig')
      for server, config in pairs(opts.servers) do
        config.capabilities =
          require('blink.cmp').get_lsp_capabilities(config.capabilities)
        lspconfig[server].setup(config)
      end
    end,
  },
}
