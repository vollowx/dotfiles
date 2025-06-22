return {
  {
    'saghen/blink.cmp',
    dependencies = 'rafamadriz/friendly-snippets',
    version = 'v1.*',
    lazy = false,
    opts_extend = { 'sources.default' },
    opts = {
      keymap = { preset = 'default' },
      -- nerd_font_variant = 'mono',
      -- accept = { auto_brackets = { enabled = true } },
      -- signature = { enabled = true },
      -- kind_icons = icons.kinds,
    },
    enabled = false,
  },

  {
    'zbirenbaum/copilot.lua',
    enabled = false,
    cmd = 'Copilot',
    event = 'InsertEnter',
    config = load_pkg('copilot'),
  },
}
