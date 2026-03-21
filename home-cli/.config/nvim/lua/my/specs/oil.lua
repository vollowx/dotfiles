return {
  {
    src = 'https://github.com/stevearc/oil.nvim',
    data = {
      after = function(_)
        -- TODO: Should be in something like before = function()
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

        local oil = require('oil')

        local border = 'none'

        oil.setup({
          columns = {
            { 'permissions', highlight = 'Normal' },
            { 'size', highlight = 'Normal' },
            { 'mtime', highlight = 'Normal' },
          },
          cleanup_delay_ms = 0,
          delete_to_trash = true,
          skip_confirm_for_simple_edits = true,
          prompt_save_on_select_new_entry = true,
          use_default_keymaps = false,
          view_options = {
            show_hidden = true,
            is_always_hidden = function(name)
              return name == '..'
            end,
          },
          keymaps = {
            ['g?'] = 'actions.show_help',
            ['K'] = preview_mapping,
            ['<C-k>'] = preview_mapping,
            ['-'] = 'actions.parent',
            ['='] = 'actions.select',
            ['+'] = 'actions.select',
            ['<CR>'] = 'actions.select',
            ['<C-h>'] = 'actions.toggle_hidden',
            ['gh'] = 'actions.toggle_hidden',
            ['gs'] = 'actions.change_sort',
            ['gx'] = 'actions.open_external',
            ['gY'] = 'actions.copy_entry_filename',
            ['go'] = {
              mode = 'n',
              buffer = true,
              desc = 'Choose an external program to open the entry under the cursor',
              callback = function()
                local entry = oil.get_cursor_entry()
                local dir = oil.get_current_dir()
                if not entry or not dir then
                  return
                end
                local entry_path = vim.fs.joinpath(dir, entry.name)
                local response
                vim.ui.input({
                  prompt = 'Open with: ',
                  completion = 'shellcmd',
                }, function(r)
                  response = r
                end)
                if not response then
                  return
                end
                print('\n')
                vim.system({ response, entry_path })
              end,
            },
            ['gy'] = {
              mode = 'n',
              buffer = true,
              desc = 'Yank the filepath of the entry under the cursor to a register',
              callback = function()
                local entry = oil.get_cursor_entry()
                local dir = oil.get_current_dir()
                if not entry or not dir then
                  return
                end
                local entry_path = vim.fs.joinpath(dir, entry.name)
                vim.fn.setreg('"', entry_path)
                vim.fn.setreg(vim.v.register, entry_path)
                vim.notify(
                  string.format(
                    "[oil] yanked '%s' to register '%s'",
                    entry_path,
                    vim.v.register
                  )
                )
              end,
            },
          },
          keymaps_help = {
            border = border,
          },
          float = {
            border = border,
            win_options = {
              winblend = 0,
            },
          },
          preview = {
            border = border,
            win_options = {
              winblend = 0,
            },
          },
          progress = {
            border = border,
            win_options = {
              winblend = 0,
            },
          },
        })

        vim.api.nvim_create_autocmd('BufEnter', {
          desc = 'Set last cursor position in oil buffers when editing parent dir.',
          group = vim.api.nvim_create_augroup('OilSetLastCursor', {}),
          pattern = 'oil:///*',
          callback = function()
            -- Place cursor on the alternate buffer if we are opening
            -- the parent directory of the alternate buffer
            local buf_alt = vim.fn.bufnr('#')
            if vim.api.nvim_buf_is_valid(buf_alt) then
              local bufname_alt = vim.api.nvim_buf_get_name(buf_alt)
              local parent_url, basename =
                oil.get_buffer_parent_url(bufname_alt, true)
              if basename then
                require('oil.view').set_last_cursor(parent_url, basename)
              end
            end
          end,
        })
      end,
    },
  },
}
