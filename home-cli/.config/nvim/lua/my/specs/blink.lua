return {
  {
    src = 'https://github.com/xzbdmw/colorful-menu.nvim',
    data = {on = 'InsertEnter'}
  },
  {
    src = 'https://github.com/saghen/blink.cmp',
    version = vim.version.range('v1.*'),
    data = {
      on = 'InsertEnter',
      after = function(_)
        require('blink.cmp').setup({
          cmdline = { enabled = false },
          completion = {
            list = { selection = { preselect = false, auto_insert = true } },
            documentation = {
              auto_show = true,
              auto_show_delay_ms = 0,
              window = { border = 'none' },
            },
            menu = {
              min_width = vim.go.pumwidth,
              max_height = vim.go.pumheight,
              draw = {
                columns = { { 'label' }, { 'kind' } },
                components = {
                  label = {
                    text = function(ctx)
                      return require('colorful-menu').blink_components_text(ctx)
                    end,
                    highlight = function(ctx)
                      return require('colorful-menu').blink_components_highlight(ctx)
                    end,
                  },
                },
              },
            },
          },
          signature = {
            enabled = true,
            window = { border = 'none' },
          },
          keymap = {
            ['<C-u>'] = { 'scroll_documentation_up', 'fallback' },
            ['<C-d>'] = { 'scroll_documentation_down', 'fallback' },
          },
          sources = {
            default = { 'lsp', 'path', 'snippets', 'buffer' },
            providers = { lsp = { timeout_ms = 500 } },
          },
          snippets = { preset = pcall(require, 'luasnip') and 'luasnip' or 'default' },
        })
      end,
    },
  },
}
