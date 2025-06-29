require('catppuccin').setup({
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
  },
  styles = {
    comments = { 'italic' },
    conditionals = { 'italic' },
    keywords = { 'italic' },
  },
  highlight_overrides = {
    all = function(c)
      return {
        FloatBorder = { bg = c.mantle, fg = c.mantle },
        StatusLine = { bg = c.mantle, fg = c.subtext1 },
      }
    end,
  },
})
