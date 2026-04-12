return {
  { src = 'https://github.com/miikanissi/modus-themes.nvim' },
  { src = 'https://github.com/sainnhe/everforest', data = { on = 'CursorHold' } },
  {
    src = 'https://github.com/catppuccin/nvim',
    name = 'catppuccin',
    data = { on = 'CursorHold' },
  },

  -- NOTE: `*:c` catches commands and search
  { src = 'https://github.com/romainl/vim-cool', data = { on = 'ModeChanged', pattern = '*:c' } },
  { src = 'https://github.com/rhysd/clever-f.vim' },
  { src = 'https://github.com/tpope/vim-sleuth', data = { on = { 'BufReadPre', 'BufNewFile' } } },
  { src = 'https://github.com/tpope/vim-fugitive' },
  { src = 'https://github.com/wakatime/vim-wakatime' },
  { src = 'https://github.com/junegunn/vim-easy-align' },

  -- {
  --   src = 'https://github.com/vimwiki/vimwiki',
  --   data = {
  --     init = function ()
  --       local wiki_path = '~/Documents/Development/vollowx/idx'
  --       vim.g.vimwiki_key_mappings = { headers = 0 }
  --       vim.g.vimwiki_list = {
  --         {
  --           path = wiki_path,
  --           path_html = wiki_path .. '/www',
  --           syntax = 'default',
  --           ext = '.wiki',
  --           custom_wiki2html = '',
  --         }
  --       }
  --     end,
  --     postload = function()
  --       vim.api.nvim_create_autocmd('FileType', {
  --         pattern = 'vimwiki',
  --         callback = function()
  --           vim.keymap.set('n', '.', '<Plug>VimwikiAddHeaderLevel', { buffer = true, desc = 'Add Header Level' })
  --           vim.keymap.set('n', ',', '<Plug>VimwikiRemoveHeaderLevel', { buffer = true, desc = 'Remove Header Level' })
  --         end,
  --       })
  --     end
  --   },
  -- },
}
