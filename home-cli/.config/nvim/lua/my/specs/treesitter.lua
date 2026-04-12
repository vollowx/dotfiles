return {
  {
    src = 'https://github.com/nvim-treesitter/nvim-treesitter',
    version = 'main',
    data = {
      postload = function(_)
        local langs = {
          'astro',
          'bash',
          'c',
          'cmake',
          'comment',
          'commonlisp',
          'cpp',
          'css',
          'csv',
          'd',
          'desktop',
          'diff',
          'editorconfig',
          'gitcommit',
          'go',
          'gomod',
          'haskell',
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
      end,
    },
  },

  {
    src = 'https://github.com/Wansmer/treesj',
    data = {
      postload = function(_)
        vim.keymap.set('n', 'J', function()
          require('treesj').toggle()
        end, { desc = 'Treesitter Join/Split' })
      end,
    },
  },
}
