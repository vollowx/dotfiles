return {
  {
    src = 'https://github.com/ej-shafran/compile-mode.nvim',
    data = {
      preload = function(_)
        vim.cmd.packadd('plenary.nvim')
        vim.g.compile_mode = {
          input_word_completion = true,
        }
      end,
    },
  },
}
