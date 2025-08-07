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
    event = 'VeryLazy',
    cmd = 'FzfLua',
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
    init = function()
      -- Disable fzf's default vim plugin
      vim.g.loaded_fzf = 1

      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.select = function(...)
        local fzf_ui = require('fzf-lua.providers.ui_select')
        -- Register fzf as custom `vim.ui.select()` function if not yet
        -- registered
        if not fzf_ui.is_registered() then
          local ui_select = fzf_ui.ui_select

          ---Overriding fzf-lua's default `ui_select()` function to use a
          ---custom prompt
          ---@diagnostic disable-next-line: duplicate-set-field
          fzf_ui.ui_select = function(items, opts, on_choice)
            -- Hack: use nbsp after ':' here because currently fzf-lua does
            -- not allow custom prompt and force substitute pattern ':%s?$'
            -- in `opts.prompt` to '> ' as the fzf prompt. We WANT the column
            -- in the prompt, so use nbsp to avoid this substitution.
            -- Also, don't use `opts.prompt:gsub(':?%s*$', ':\xc2\xa0')` here
            -- because it does a non-greedy match and will not substitute
            -- ':' at the end of the prompt, e.g. if `opts.prompt` is
            -- 'foobar: ' then result will be 'foobar: : ', interestingly
            -- this behavior changes in Lua 5.4, where the match becomes
            -- greedy, i.e. given the same string and substitution above the
            -- result becomes 'foobar> ' as expected.
            opts.prompt = opts.prompt
              and vim.fn.substitute(opts.prompt, ':\\?\\s*$', ':\xc2\xa0', '')
            ui_select(items, opts, on_choice)
          end

          -- Use the register function provided by fzf-lua. We are using this
          -- wrapper instead of directly replacing `vim.ui.selct()` with fzf
          -- select function because in this way we can pass a callback to this
          -- `register()` function to generate fzf opts in different contexts,
          -- see https://github.com/ibhagwan/fzf-lua/issues/755
          -- Here we use the callback to achieve adaptive height depending on
          -- the number of items, with a max height of 10, the `split` option
          -- is basically the same as that used in fzf config file:
          -- lua/configs/fzf-lua.lua
          fzf_ui.register(function(_, items)
            local height = #items + 1
            return {
              winopts = {
                split = string.format(
                  -- Don't shrink size if a quickfix list is closed for fzf
                  -- window to avoid window resizing and content shifting
                  '%s | if get(g:, "_fzf_qfclosed", "") == "" && %d < winheight(0) | resize %d | endif',
                  vim.trim(require('fzf-lua.config').setup_opts.winopts.split),
                  height,
                  height
                ),
              },
            }
          end)
        end
        vim.ui.select(...)
      end
    end,
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
