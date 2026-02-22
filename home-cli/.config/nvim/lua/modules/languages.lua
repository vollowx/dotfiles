return {
  {
    'iamcco/markdown-preview.nvim',
    enabled = vim.g.has_gui,
    ft = 'markdown',
    build = 'cd app && bun install && cd - && git restore .',
    config = function()
      require('configs.markdown-preview')
    end,
  },

  {
    'dhruvasagar/vim-table-mode',
    cmd = 'TableModToggle',
    ft = 'markdown',
    config = function()
      require('configs.table-mode')
    end,
  },
}
