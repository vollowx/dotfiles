return {
  {
    'tpope/vim-sleuth',
    event = { 'BufReadPre', 'StdinReadPre' },
  },

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
    config = function()
      require('configs.ultimate-autopair')
    end,
  },

  {
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        'gq',
        function()
          require('conform').format({ async = true })
        end,
        mode = '',
      },
    },
    init = function()
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
    config = function ()
      require('configs.conform')
    end
  },
}
