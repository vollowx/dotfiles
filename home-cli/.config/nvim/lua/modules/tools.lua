return {
  {
    'dstein64/vim-startuptime',
    lazy = false,
  },

  {
    'wakatime/vim-wakatime',
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
    config = function()
      require('configs.oil')
    end,
  },

  {
    'lewis6991/gitsigns.nvim',
    event = 'BufReadPre',
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
    config = function()
      require('configs.gitsigns')
    end,
  },

  {
    'ibhagwan/fzf-lua',
    event = 'LspAttach',
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
      { '<Leader>.', desc = 'Find files' },
      { "<Leader>'", desc = 'Resume last picker' },
      { '<Leader>`', desc = 'Find marks' },
      { '<Leader>,', desc = 'Find buffers' },
      { '<Leader>%', desc = 'Find tabpages' },
      { '<Leader>/', desc = 'Grep' },
      { '<Leader>?', desc = 'Find help files' },
      { '<Leader>*', mode = { 'n', 'x' }, desc = 'Grep word under cursor' },
      { '<Leader>#', mode = { 'n', 'x' }, desc = 'Grep word under cursor' },
      { '<Leader>"', desc = 'Find registers' },
      { '<Leader>:', desc = 'Find commands' },
      { '<Leader>F', desc = 'Find all available pickers' },
      { '<Leader>o', desc = 'Find oldfiles' },
      { '<Leader>-', desc = 'Find lines in buffer' },
      { '<Leader>=', desc = 'Find lines across buffers' },
      { '<Leader>-', desc = 'Find lines in selection', mode = 'x' },
      { '<Leader>=', desc = 'Find lines in selection', mode = 'x' },
      { '<Leader>n', desc = 'Find treesitter nodes' },
      { '<Leader>R', desc = 'Find symbol locations' },
      { '<Leader>f"', desc = 'Find registers' },
      { '<Leader>f*', mode = { 'n', 'x' }, desc = 'Grep word under cursor' },
      { '<Leader>f#', mode = { 'n', 'x' }, desc = 'Grep word under cursor' },
      { '<Leader>f:', desc = 'Find commands' },
      { '<Leader>f/', desc = 'Grep' },
      { '<Leader>fH', desc = 'Find highlights' },
      { "<Leader>f'", desc = 'Resume last picker' },
      { '<Leader>fA', desc = 'Find autocmds' },
      { '<Leader>fb', desc = 'Find buffers' },
      { '<Leader>fp', desc = 'Find tabpages' },
      { '<Leader>ft', desc = 'Find tags' },
      { '<Leader>fc', desc = 'Find changes' },
      { '<Leader>fd', desc = 'Find document diagnostics' },
      { '<Leader>fD', desc = 'Find workspace diagnostics' },
      { '<Leader>ff', desc = 'Find files' },
      { '<Leader>fa', desc = 'Find args' },
      { '<Leader>fl', desc = 'Find location list' },
      { '<Leader>fq', desc = 'Find quickfix list' },
      { '<Leader>fL', desc = 'Find location list stack' },
      { '<Leader>fQ', desc = 'Find quickfix stack' },
      { '<Leader>fgt', desc = 'Find git tags' },
      { '<Leader>fgs', desc = 'Find git stash' },
      { '<Leader>fgg', desc = 'Find git status' },
      { '<Leader>fgL', desc = 'Find git logs' },
      { '<Leader>fgl', desc = 'Find git buffer logs' },
      { '<Leader>fgb', desc = 'Find git branches' },
      { '<Leader>fgB', desc = 'Find git blame' },
      { '<Leader>gft', desc = 'Find git tags' },
      { '<Leader>gfs', desc = 'Find git stash' },
      { '<Leader>gfg', desc = 'Find git status' },
      { '<Leader>gfL', desc = 'Find git logs' },
      { '<Leader>gfl', desc = 'Find git buffer logs' },
      { '<Leader>gfb', desc = 'Find git branches' },
      { '<Leader>gfB', desc = 'Find git blame' },
      { '<Leader>fh', desc = 'Find help files' },
      { '<Leader>fk', desc = 'Find keymaps' },
      { '<Leader>f-', desc = 'Find lines in buffer' },
      { '<Leader>f-', desc = 'Find lines in selection', mode = 'x' },
      { '<Leader>f=', desc = 'Find lines across buffers' },
      { '<Leader>fm', desc = 'Find marks' },
      { '<Leader>fo', desc = 'Find oldfiles' },
      { '<Leader>fSa', desc = 'Find code actions' },
      { '<Leader>fSd', desc = 'Find symbol definitions' },
      { '<Leader>fSD', desc = 'Find symbol declarations' },
      { '<Leader>fS<C-d>', desc = 'Find symbol type definitions' },
      { '<Leader>fSs', desc = 'Find symbol in current document' },
      { '<Leader>fSS', desc = 'Find symbol in whole workspace' },
      { '<Leader>fSi', desc = 'Find symbol implementations' },
      { '<Leader>fS<', desc = 'Find symbol incoming calls' },
      { '<Leader>fS>', desc = 'Find symbol outgoing calls' },
      { '<Leader>fSr', desc = 'Find symbol references' },
      { '<Leader>fSR', desc = 'Find symbol locations' },
      { '<Leader>fF', desc = 'Find all available pickers' },
    },
    config = function()
      require('configs.fzf')
    end,
  },

  {
    'stevearc/quicker.nvim',
    event = 'VeryLazy',
    config = function()
      require('configs.quicker')
    end,
  },
}
