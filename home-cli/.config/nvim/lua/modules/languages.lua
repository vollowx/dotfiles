return {
  {
    'iamcco/markdown-preview.nvim',
    enabled = vim.g.has_gui,
    ft = 'markdown',
    build = 'cd app && npm install && cd - && git restore .',
    config = function ()
      require('configs.markdown-preview')
    end
  },

  {
    'dhruvasagar/vim-table-mode',
    cmd = 'TableModToggle',
    ft = 'markdown',
    config = function ()
      require('configs.table-mode')
    end
  },

  {
    'lukas-reineke/headlines.nvim',
    ft = { 'markdown', 'norg', 'rmd', 'org' },
    config = function ()
      require('configs.headlines')
    end
  },
}
