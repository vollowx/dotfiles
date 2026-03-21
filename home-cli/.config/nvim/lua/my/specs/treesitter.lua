return {
  {
    src = 'https://github.com/nvim-treesitter/nvim-treesitter',
    data = {
      after = function(_)
        local langs = {
          'astro',
          'bash',
          'c',
          'cmake',
          'comment',
          'cpp',
          'css',
          'csv',
          'desktop',
          'diff',
          'editorconfig',
          'gitcommit',
          'go',
          'gomod',
          'html',
          'javascript',
          'json',
          'lua',
          'make',
          'markdown',
          'markdown_inline',
          'python',
          'rust',
          'toml',
          'typescript',
          'vim',
          'vimdoc',
          'yaml',
          'zig',
        }

        require('nvim-treesitter').install(langs)

        for _, lang in ipairs(langs) do
          vim.api.nvim_create_autocmd('FileType', {
            pattern = { lang },
            callback = function()
              vim.treesitter.start()
              vim.wo.fdm = 'expr'
              vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
              vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
            end,
          })
        end
      end,
    },
  },

  {
    src = 'https://github.com/Wansmer/treesj',
    data = {
      after = function(_)
        vim.keymap.set('n', 'J', function()
          require('treesj').toggle()
        end, { desc = 'Treesitter Join/Split' })

        require('treesj').setup({})
      end,
    },
  },
}
