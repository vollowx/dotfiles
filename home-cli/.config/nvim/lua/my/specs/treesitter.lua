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
            callback = function(ev)
              vim.treesitter.start(ev.buf, lang)
              vim.wo[0][0].fdm = 'expr'
              vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
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
      postload = function(_)
        vim.keymap.set('n', 'J', function()
          require('treesj').toggle()
        end, { desc = 'Treesitter Join/Split' })
      end,
    },
  },
}
