local filetypes = {
  'astro',
  'bash',
  'c',
  'cmake',
  'comment',
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
  'hs',
  'html',
  'js',
  'json',
  'lisp',
  'lua',
  'make',
  'markdown',
  'python',
  'rust',
  'toml',
  'ts',
  'vim',
  'vimdoc',
  'yaml',
  'zig',
}

for _, filetype in ipairs(filetypes) do
  vim.api.nvim_create_autocmd('FileType', {
    pattern = { filetype },
    callback = function(ev)
      local successful = pcall(vim.treesitter.start, ev.buf)
      if not successful then
        return
      end
      vim.wo[0][0].fdm = 'expr'
      vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
      vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end,
  })
end
