require('catppuccin').setup({
  term_colors = true,
  default_integrations = false,
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
    beacon = true,
    blink_cmp = true,
    copilot_vim = true,
    fzf = true,
    gitsigns = true,
    headlines = true,
    indent_blankline = { enabled = true, scope_color = 'surface1' },
    markdown = true,
    mini = { enabled = true },
    noice = true,
    semantic_tokens = true,
    telescope = { enabled = true, style = 'nvchad' },
    treesitter_context = true,
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
