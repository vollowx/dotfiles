return {
  {
    'junegunn/vim-easy-align',
    lazy = false,
    keys = {
      { 'ga', '<Plug>(EasyAlign)', mode = { 'n', 'x' } },
    },
  },

  {
    'altermo/ultimate-autopair.nvim',
    event = { 'InsertEnter', 'CmdlineEnter' },
    config = load_pkg('ultimate-autopair'),
  },

  {
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        -- Customize or remove this keymap to your liking
        'gq',
        function()
          require('conform').format({ async = true })
        end,
        mode = '',
      },
    },
    ---@module 'conform'
    ---@type conform.setupOpts
    opts = {
      formatters_by_ft = {
        ['_'] = { 'trim_whitespace' },
        sh = { 'shfmt' },
        c = { 'clang-format' },
        cpp = { 'clang-format' },
        lua = { 'stylua' },
        python = { 'isort', 'black' },
        html = { 'prettierd', 'prettier', stop_after_first = true },
        css = { 'prettierd', 'prettier', stop_after_first = true },
        scss = { 'prettierd', 'prettier', stop_after_first = true },
        javascript = { 'prettierd', 'prettier', stop_after_first = true },
        typescript = { 'prettierd', 'prettier', stop_after_first = true },
      },
      default_format_opts = {
        lsp_format = 'fallback',
      },
      format_on_save = { timeout_ms = 500 },
      formatters = {
        shfmt = {
          prepend_args = { '-i', '2' },
        },
      },
    },
    init = function()
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
  },
}
