return {
  {
    'rafcamlet/nvim-luapad',
    cmd = { 'Luapad' },
  },

  {
    'nvzone/minty',
    cmd = { 'Shades', 'Huefy' },
  },

  { 'nvzone/typr', cmd = { 'Typr' } },

  {
    'wakatime/vim-wakatime',
    event = { 'BufReadPre', 'BufNewFile' },
  },

  {
    'NMAC427/guess-indent.nvim',
    cmd = { 'GuessIndent' },
    event = { 'BufReadPre', 'BufNewFile' },
  },

  {
    'echasnovski/mini.bufremove',
    keys = {
      {
        '<Leader>x',
        function()
          require('mini.bufremove').delete()
        end,
        desc = 'Close current buffer',
      },
    },
  },

  {
    'echasnovski/mini.jump',
    config = load_pkg('mini-jump'),
    keys = {
      { 'f', mode = { 'n', 'x' } },
      { 'F', mode = { 'n', 'x' } },
      { 't', mode = { 'n', 'x' } },
      { 'T', mode = { 'n', 'x' } },
      { ';', mode = { 'n', 'x' } },
    },
  },

  {
    'tpope/vim-fugitive',
    dependencies = 'tpope/vim-rhubarb',
    event = { 'BufWritePost', 'BufReadPre' },
    cmd = {
      'G',
      'Gcd',
      'Gclog',
      'Gdiffsplit',
      'Gdrop',
      'Gedit',
      'Ggrep',
      'Git',
      'Glcd',
      'Glgrep',
      'Gllog',
      'Gpedit',
      'Gread',
      'Gsplit',
      'Gtabedit',
      'Gvdiffsplit',
      'Gvsplit',
      'Gwq',
      'Gwrite',
    },
  },

  {
    'stevearc/oil.nvim',
    dependencies = { 'nvim-web-devicons' },
    cmd = { 'Oil' },
    init = function() -- Load oil on startup only when editing a directory
      vim.g.loaded_fzf_file_explorer = 1
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1
      vim.api.nvim_create_autocmd('BufWinEnter', {
        nested = true,
        callback = function(info)
          local path = info.file
          if path == '' then
            return
          end
          local stat = vim.uv.fs_stat(path)
          if stat and stat.type == 'directory' then
            vim.api.nvim_del_autocmd(info.id)
            require('oil')
            vim.cmd.edit({
              bang = true,
              mods = { keepjumps = true },
            })
            return true
          end
        end,
      })
    end,
    config = load_pkg('oil'),
  },

  {
    'lewis6991/gitsigns.nvim',
    event = 'BufReadPre',
    config = load_pkg('gitsigns'),
    keys = {
      { '<Leader>g', '<Nop>', desc = 'Git...' },
      {
        '<Leader>gd',
        '<Cmd>Gitsigns diffthis<CR>',
        desc = 'Diff',
      },
      {
        '<Leader>gl',
        '<Cmd>Gitsigns blame_line<CR>',
        desc = 'Line blame',
      },
    },
  },

  {
    'ibhagwan/fzf-lua',
    event = 'LspAttach',
    config = load_pkg('fzf'),
    cmd = {
      'FzfLua',
      'FZF',
      'Ls',
      'Args',
      'Tabs',
      'Tags',
      'Files',
      'Marks',
      'Jumps',
      'Autocmd',
      'Buffers',
      'Changes',
      'Display',
      'Oldfiles',
      'Registers',
      'Highlight',
    },
    keys = {
      '<Leader>.',
      '<Leader>,',
      '<Leader>/',
      '<Leader>?',
      '<Leader>"',
      '<Leader>o',
      "<Leader>'",
      '<Leader>-',
      '<Leader>=',
      '<Leader>R',
      '<Leader>F',
      '<Leader>f',
      '<Leader>ff',
      { '<Leader>*', mode = { 'n', 'x' } },
      { '<Leader>#', mode = { 'n', 'x' } },
    },
  },
}
