require('catppuccin').setup({
  float = {
    transparent = false,
    solid = true,
  },
  term_colors = true,
  default_integrations = false,
  auto_integrations = true,
  integrations = {
    treesitter = true,
    native_lsp = {
      enabled = true,
      virtual_text = {
        errors = { 'italic' },
        hints = { 'italic' },
        warnings = { 'italic' },
        information = { 'italic' },
      },
      underlines = {
        errors = { 'undercurl' },
        hints = { 'undercurl' },
        warnings = { 'undercurl' },
        information = { 'undercurl' },
      },
      inlay_hints = { background = true },
    },
    telescope = true,
  },
  highlight_overrides = {
    all = function(c)
      return {
        CursorLineNr = { fg = c.lavender, style = { 'bold' } },
      }
    end,
  },
})
