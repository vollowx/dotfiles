return {
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    lazy = false,
    build = ':TSUpdate',
    config = function()
      local languages = {
        'astro',
        'bash',
        'c',
        'cmake',
        'comment',
        'cpp',
        'csv',
        'diff',
        'gitcommit',
        'go',
        'html',
        'javascript',
        'json',
        'lua',
        'make',
        'markdown',
        'markdown_inline',
        'nix',
        'python',
        'rust',
        'toml',
        'typescript',
        'vim',
        'vimdoc',
        'yaml',
      }

      require('nvim-treesitter').install(languages)

      for _, server in ipairs(languages) do
        vim.api.nvim_create_autocmd('FileType', {
          pattern = { server },
          callback = function()
            vim.treesitter.start()
            vim.wo.fdm = 'expr'
            vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
            -- indentation, provided by nvim-treesitter
            vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end,
        })
      end
    end,
  },

  -- {
  --   'RRethy/nvim-treesitter-endwise',
  --   dependencies = 'nvim-treesitter/nvim-treesitter',
  --   event = 'InsertEnter',
  --   config = function()
  --     -- Manually trigger `FileType` event to make nvim-treesitter-endwise
  --     -- attach to current file when loaded
  --     vim.api.nvim_exec_autocmds('FileType', {})
  --   end,
  -- },

  {
    'tronikelis/ts-autotag.nvim',
    event = 'InsertEnter',
    dependencies = 'nvim-treesitter/nvim-treesitter',
    config = true,
  },

  {
    'Wansmer/treesj',
    cmd = { 'TSJToggle', 'TSJSplit', 'TSJJoin' },
    keys = {
      {
        'J',
        function()
          require('treesj').toggle()
        end,
      },
    },
    dependencies = 'nvim-treesitter/nvim-treesitter',
  },
}
