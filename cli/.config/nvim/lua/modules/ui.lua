return {
  {
    'romainl/vim-cool',
    lazy = false,
  },

  {
    'brenoprata10/nvim-highlight-colors',
    enabled = vim.g.has_gui,
    event = 'VeryLazy',
    config = load_pkg('highlight-colors'),
  },

  {
    'tzachar/local-highlight.nvim',
    event = 'VeryLazy',
    config = load_pkg('local-highlight'),
  },

  {
    'Aasim-A/scrollEOF.nvim',
    event = { 'CursorMoved', 'WinScrolled' },
    config = load_pkg('scroll-eof'),
  },

  {
    'nvzone/showkeys',
    cmd = 'ShowkeysToggle',
    opts = { winopts = { border = 'none' } },
  },

  {
    'folke/noice.nvim',
    event = 'VeryLazy',
    opts = {
      presets = {
        command_palette = true,
      },

      cmdline = {
        format = {
          cmdline = { pattern = '^:', icon = icons.ui.Cmd, lang = 'vim' },
          search_down = {
            kind = 'search',
            pattern = '^/',
            icon = icons.ui.Magnify .. vim.trim(icons.ui.ArrowDown),
            lang = 'regex',
          },
          search_up = {
            kind = 'search',
            pattern = '^%?',
            icon = icons.ui.Magnify .. vim.trim(icons.ui.ArrowUp),
            lang = 'regex',
          },
          filter = { pattern = '^:%s*!', icon = '$ ', lang = 'bash' },
          lua = {
            pattern = { '^:%s*lua%s+', '^:%s*lua%s*=%s*', '^:%s*=%s*' },
            icon = icons.ft.Lua,
            lang = 'lua',
          },
          help = { pattern = '^:%s*he?l?p?%s+', icon = icons.ui.Help },
          input = { view = 'cmdline_input', icon = icons.ui.Play }, -- Used by input()
        },
      },

      messages = { enabled = false },
      notify = { enabled = false },
      lsp = {
        progress = { enabled = false },
        hover = { enabled = false },
        signature = { enabled = false },
        message = { enabled = false },
        documentation = { opts = { replace = false } },
      },
    },
  },
}
