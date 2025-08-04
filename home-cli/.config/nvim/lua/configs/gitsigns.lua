local icons = require('utils.icons')

require('gitsigns').setup({
  preview_config = {
    border = 'single',
    style = 'minimal',
  },
  signs = {
    add = { text = vim.trim(icons.ui.GitSignAdd) },
    untracked = { text = vim.trim(icons.ui.GitSignUntracked) },
    change = { text = vim.trim(icons.ui.GitSignChange) },
    delete = { text = vim.trim(icons.ui.GitSignDelete) },
    topdelete = { text = vim.trim(icons.ui.GitSignTopdelete) },
    changedelete = { text = vim.trim(icons.ui.GitSignChangedelete) },
  },
  signcolumn = true,
  current_line_blame = true,
  current_line_blame_formatter = ' ' .. '<author>, <author_time:%R>',
  current_line_blame_formatter_nc = ' ' .. '<author>',
  current_line_blame_opts = { delay = 0 },
  attach_to_untracked = true,
})
