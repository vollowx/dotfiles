return {
  {
    src = 'https://github.com/lewis6991/gitsigns.nvim',
    data = {
      on = 'BufReadPre',
      after = function(_)
        local icons = require('my.utils.icons')

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
          current_line_blame = false,
          attach_to_untracked = true,
        })
      end,
    },
  },
}
