return {
  {
    src = 'https://github.com/Wansmer/symbol-usage.nvim',
    data = {
      on = 'LspAttach',
      load = function(data)
        vim.cmd.packadd(data.spec.name)
        require('symbol-usage').setup({})
      end,
    },
  },
}
