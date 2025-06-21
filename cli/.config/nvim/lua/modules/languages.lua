return {
  {
    'iamcco/markdown-preview.nvim',
    enabled = vim.g.has_gui,
    ft = 'markdown',
    build = 'cd app && npm install && cd - && git restore .',
    config = load_pkg('markdown-preview'),
  },

  {
    'dhruvasagar/vim-table-mode',
    cmd = 'TableModToggle',
    ft = 'markdown',
    config = load_pkg('table-mode'),
  },

  {
    'lukas-reineke/headlines.nvim',
    ft = { 'markdown', 'norg', 'rmd', 'org' },
    config = load_pkg('headlines', true),
  },
}
