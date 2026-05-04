return {
  {
    src = 'https://github.com/nvim-orgmode/orgmode',
    data = {
      postload = function(_)
        require('orgmode').setup({
          org_agenda_files = '~/Documents/Org/**/*',
          org_default_notes_file = '~/Documents/Org/refile.org',
          org_startup_indented = true,
          org_todo_keywords = {
            'TODO',
            '|',
            'DONE',
            'DELEGATED',
          },
          org_agenda_sorting_strategy = {
            agenda = {
              'time-up',
              'todo-state-up',
              'priority-down',
              'category-keep',
            },
          },
        })

        vim.lsp.enable('org')
      end,
    },
  },

  {
    src = 'https://github.com/nvim-orgmode/org-bullets.nvim',
    data = {
      postload = function(_)
        require('org-bullets').setup({
          concealcursor = true,
        })
      end,
    },
  },
}
