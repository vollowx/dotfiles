return {
  {
    src = 'https://github.com/nvim-orgmode/orgmode',
    data = {
      postload = function(_)
        require('orgmode').setup({
          org_agenda_files = '~/Documents/Org/**/*',
          org_default_notes_file = '~/Documents/Org/refile.org',
          org_todo_keywords = {
            'TODO',
            'NEXT',
            'STRT',
            '|',
            'DONE',
            'DELEGATED',
          },
        })

        vim.lsp.enable('org')
      end,
    },
  },
}
