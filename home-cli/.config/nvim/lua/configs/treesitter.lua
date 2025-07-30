local ts = require('nvim-treesitter.configs')

vim.api.nvim_set_option_value('foldmethod', 'expr', {})
vim.api.nvim_set_option_value('foldexpr', 'nvim_treesitter#foldexpr()', {})

ts.setup({
  auto_install = false,
  sync_install = false,
  ignore_install = { 'org' },
  ensure_installed = {
    'c',
    'lua',
    'vim',
    'bash',
    'query',
    'python',
    'vimdoc',
    'markdown',
    'markdown_inline',

    'cpp',
    'css',
    'csv',
    'nix',
    'zig',
    'kdl',
    'ini',
    'fish',
    'rust',
    'make',
    'json',
    'yaml',
    'toml',
    'html',
    'javascript',
    'typescript',

    'gitcommit',
    'gitignore',
  },
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  indent = { enable = true },
  endwise = { enable = true },
})
