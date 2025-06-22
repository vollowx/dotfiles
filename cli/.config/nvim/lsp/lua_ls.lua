return {
  cmd = { 'lua-language-server' },
  filetypes = { 'lua' },
  settings = {
    Lua = {
      hint = { enable = true },
      format = { enable = false },
      telemetry = { enable = false },
      workspace = {
        library = {
          vim.env.VIMRUNTIME,
        },
      },
    },
  },
}
