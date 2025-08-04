require('blink.cmp').setup({
  completion = {
    list = {
      selection = {
        preselect = false,
        auto_insert = true,
      },
    },
    documentation = {
      auto_show = true,
      auto_show_delay_ms = 0,
      window = {
        border = 'solid',
      },
    },
    menu = {
      draw = {
        columns = { { 'label', gap = 2 }, { 'kind' } },
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
  signature = { enabled = true },
  keymap = { preset = 'default' },
  sources = { default = { 'lsp', 'path', 'snippets' } },
  snippets = {
    preset = pcall(require, 'luasnip') and 'luasnip' or 'default',
  },
})
