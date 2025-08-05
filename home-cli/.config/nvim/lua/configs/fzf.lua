if vim.fn.executable('fzf') == 0 then
  vim.notify('[Fzf-lua] command `fzf` not found', vim.log.levels.ERROR)
  return
end

local actions = require('fzf-lua.actions')
local config = require('fzf-lua.config')
local core = require('fzf-lua.core')
local fzf = require('fzf-lua')
local icons = require('utils.icons')
local path = require('fzf-lua.path')
local utils = require('utils')

local _arg_del = actions.arg_del
local _vimcmd_buf = actions.vimcmd_buf

---@diagnostic disable-next-line: duplicate-set-field
function actions.arg_del(...)
  pcall(_arg_del, ...)
end

---@diagnostic disable-next-line: duplicate-set-field
function actions.vimcmd_buf(...)
  pcall(_vimcmd_buf, ...)
end

local _mt_cmd_wrapper = core.mt_cmd_wrapper

---Wrap `core.mt_cmd_wrapper()` used in fzf-lua's file and grep providers
---to ignore `opts.cwd` when generating the command string because once the
---cwd is hard-coded in the command string, `opts.cwd` will be ignored.
---
---This fixes the bug where `switch_cwd()` does not work if it is used after
---`switch_provider()`:
---
---In `switch_provider()`, `opts.cwd` will be passed the corresponding fzf
---provider (file or grep) where it will be compiled in the command string,
---which will then be stored in `fzf.config.__resume_data.contents`.
---
---`switch_cwd()` internally calls the resume action to resume the last
---provider and reuse other info in previous fzf session (e.g. last query, etc)
---except `opts.cwd`, `opts.fn_selected`, etc. that needs to be changed to
---reflect the new cwd.
---
---Thus if `__resume_data.contents` contains information about the previous
---cwd, the new cwd in `opts.cwd` will be ignored and `switch_cwd()` will not
---take effect.
---@param opts table?
---@diagnostic disable-next-line: duplicate-set-field
function core.mt_cmd_wrapper(opts)
  if not opts or not opts.cwd then
    return _mt_cmd_wrapper(opts)
  end
  local _opts = {}
  for k, v in pairs(opts) do
    _opts[k] = v
  end
  _opts.cwd = nil
  return _mt_cmd_wrapper(_opts)
end

---Switch provider while preserving the last query and cwd
---@return nil
function actions.switch_provider()
  local opts = {
    query = fzf.config.__resume_data.last_query,
    cwd = fzf.config.__resume_data.opts.cwd,
  }
  fzf.builtin({
    actions = {
      ['default'] = function(selected)
        fzf[selected[1]](opts)
      end,
      ['esc'] = actions.resume,
    },
  })
end

---Switch cwd while preserving the last query
---@return nil
function actions.switch_cwd()
  fzf.config.__resume_data.opts = fzf.config.__resume_data.opts or {}
  local opts = fzf.config.__resume_data.opts

  -- Remove old fn_selected, else selected item will be opened
  -- with previous cwd
  opts.fn_selected = nil
  opts.cwd = opts.cwd or vim.uv.cwd()
  opts.query = fzf.config.__resume_data.last_query

  vim.ui.input({
    prompt = 'New cwd: ',
    default = opts.cwd,
    completion = 'dir',
  }, function(input)
    if not input then
      return
    end
    input = vim.fs.normalize(input)
    local stat = vim.uv.fs_stat(input)
    if not stat or not stat.type == 'directory' then
      print('\n')
      vim.notify(
        '[Fzf-lua] invalid path: ' .. input .. '\n',
        vim.log.levels.ERROR
      )
      vim.cmd.redraw()
      return
    end
    opts.cwd = input
  end)

  -- Adapted from fzf-lua `core.set_header()` function
  if opts.cwd_prompt then
    opts.prompt = vim.fn.fnamemodify(opts.cwd, ':.:~')
    local shorten_len = tonumber(opts.cwd_prompt_shorten_len)
    if shorten_len and #opts.prompt >= shorten_len then
      opts.prompt =
        path.shorten(opts.prompt, tonumber(opts.cwd_prompt_shorten_val) or 1)
    end
    if not path.ends_with_separator(opts.prompt) then
      opts.prompt = opts.prompt .. path.separator()
    end
  end

  if opts.headers then
    opts = core.set_header(opts, opts.headers)
  end

  actions.resume()
end

---Delete selected autocmd
---@return nil
function actions.del_autocmd(selected)
  for _, line in ipairs(selected) do
    local event, group, pattern =
      line:match('^.+:%d+:(%w+)%s*│%s*(%S+)%s*│%s*(.-)%s*│')
    if event and group and pattern then
      vim.cmd.autocmd({
        bang = true,
        args = { group, event, pattern },
        mods = { emsg_silent = true },
      })
    end
  end
  local query = fzf.config.__resume_data.last_query
  fzf.autocmds({
    fzf_opts = {
      ['--query'] = query ~= '' and query or nil,
    },
  })
end

---Search & select files then add them to arglist
---@return nil
function actions.arg_search_add()
  local opts = fzf.config.__resume_data.opts
  fzf.files({
    cwd_header = true,
    cwd_prompt = false,
    headers = { 'actions', 'cwd' },
    prompt = 'Argadd> ',
    actions = {
      ['default'] = function(selected, _opts)
        local cmd = 'argadd'
        vim.ui.input({
          prompt = 'Argadd cmd: ',
          default = cmd,
        }, function(input)
          if input then
            cmd = input
          end
        end)
        actions.vimcmd_file(cmd, selected, _opts)
        fzf.args(opts)
      end,
      ['esc'] = function()
        fzf.args(opts)
      end,
    },
    find_opts = [[-type f -type d -type l -not -path '*/\.git/*' -printf '%P\n']],
    fd_opts = [[--color=never --type f --type d --type l --hidden --follow --exclude .git]],
    rg_opts = [[--color=never --files --hidden --follow -g '!.git'"]],
  })
end

function actions._file_edit_or_qf(selected, opts)
  if #selected > 1 then
    actions.file_sel_to_qf(selected, opts)
    vim.cmd.cfirst()
    vim.cmd.copen()
  else
    actions.file_edit(selected, opts)
  end
end

function actions._file_sel_to_qf(selected, opts)
  actions.file_sel_to_qf(selected, opts)
  if #selected > 1 then
    vim.cmd.cfirst()
    vim.cmd.copen()
  end
end

function actions._file_sel_to_ll(selected, opts)
  actions.file_sel_to_ll(selected, opts)
  if #selected > 1 then
    vim.cmd.lfirst()
    vim.cmd.lopen()
  end
end

core.ACTION_DEFINITIONS[actions.toggle_ignore] =
  { 'Disable .gitignore', fn_reload = 'Respect .gitignore' }
core.ACTION_DEFINITIONS[actions.switch_cwd] = { 'Change Cwd', pos = 1 }
core.ACTION_DEFINITIONS[actions.arg_del] = { 'delete' }
core.ACTION_DEFINITIONS[actions.del_autocmd] = { 'delete autocmd' }
core.ACTION_DEFINITIONS[actions.arg_search_add] = { 'add new file' }
core.ACTION_DEFINITIONS[actions.search] = { 'edit' }
core.ACTION_DEFINITIONS[actions.ex_run] = { 'edit' }

-- stylua: ignore start
config._action_to_helpstr[actions.toggle_ignore] = 'toggle-ignore'
config._action_to_helpstr[actions.switch_provider] = 'switch-provider'
config._action_to_helpstr[actions.switch_cwd] = 'change-cwd'
config._action_to_helpstr[actions.arg_del] = 'delete'
config._action_to_helpstr[actions.del_autocmd] = 'delete-autocmd'
config._action_to_helpstr[actions.arg_search_add] = 'search-and-add-new-file'
config._action_to_helpstr[actions.buf_sel_to_qf] = 'buffer-select-to-quickfix'
config._action_to_helpstr[actions.buf_sel_to_ll] = 'buffer-select-to-loclist'
config._action_to_helpstr[actions._file_sel_to_qf] = 'file-select-to-quickfix'
config._action_to_helpstr[actions._file_sel_to_ll] = 'file-select-to-loclist'
config._action_to_helpstr[actions._file_edit_or_qf] = 'file-edit-or-qf'
-- stylua: ignore end

-- Use different prompts for document and workspace diagnostics
-- by overriding `fzf.diagnostics_workspace()` and `fzf.diagnostics_document()`
-- because fzf-lua does not support setting different prompts for them via
-- the `fzf.setup()` function, see `defaults.lua` & `providers/diagnostic.lua`
local _diagnostics_workspace = fzf.diagnostics_workspace
local _diagnostics_document = fzf.diagnostics_document

---@param opts table?
function fzf.diagnostics_document(opts)
  return _diagnostics_document(vim.tbl_extend('force', opts or {}, {
    prompt = 'Document Diagnostics> ',
  }))
end

---@param opts table?
function fzf.diagnostics_workspace(opts)
  return _diagnostics_workspace(vim.tbl_extend('force', opts or {}, {
    prompt = 'Workspace Diagnostics> ',
  }))
end

vim.lsp.buf.incoming_calls = fzf.lsp_incoming_calls
vim.lsp.buf.outgoing_calls = fzf.lsp_outgoing_calls
vim.lsp.buf.declaration = fzf.declarations
vim.lsp.buf.definition = fzf.lsp_definitions
vim.lsp.buf.document_symbol = fzf.lsp_document_symbols
vim.lsp.buf.implementation = fzf.lsp_implementations
vim.lsp.buf.references = fzf.lsp_references
vim.lsp.buf.type_definition = fzf.lsp_typedefs
vim.lsp.buf.workspace_symbol = fzf.lsp_live_workspace_symbols

vim.diagnostic.setqflist = fzf.diagnostics_workspace
vim.diagnostic.setloclist = fzf.diagnostics_document

fzf.setup({
  -- Use nbsp in tty to avoid showing box chars
  nbsp = not vim.g.has_gui and '\xc2\xa0' or nil,
  dir_icon = vim.trim(icons.kinds.Folder),
  winopts = {
    backdrop = 100,
    split = [[
        let tabpage_win_list = nvim_tabpage_list_wins(0) |
        \ call v:lua.require'utils.win'.saveheights(tabpage_win_list) |
        \ call v:lua.require'utils.win'.saveviews(tabpage_win_list) |
        \ unlet tabpage_win_list |
        \ let g:_fzf_vim_lines = &lines |
        \ let g:_fzf_leave_win = win_getid(winnr()) |
        \ let g:_fzf_splitkeep = &splitkeep | let &splitkeep = "topline" |
        \ let g:_fzf_cmdheight = &cmdheight | let &cmdheight = 0 |
        \ let g:_fzf_laststatus = &laststatus | let &laststatus = 0 |
        \ botright 10new |
        \ exe 'resize' .
          \ (10 + g:_fzf_cmdheight + (g:_fzf_laststatus ? 1 : 0)) |
        \ let w:winbar_no_attach = v:true |
        \ setlocal bt=nofile bh=wipe nobl noswf wfh
    ]],
    on_create = function()
      vim.keymap.set(
        't',
        '<C-r>',
        [['<C-\><C-N>"' . nr2char(getchar()) . 'pi']],
        { expr = true, buffer = true }
      )
    end,
    on_close = function()
      ---@param name string
      ---@return nil
      local function _restore_global_opt(name)
        if vim.g['_fzf_' .. name] then
          vim.go[name] = vim.g['_fzf_' .. name]
          vim.g['_fzf_' .. name] = nil
        end
      end

      _restore_global_opt('splitkeep')
      _restore_global_opt('cmdheight')
      _restore_global_opt('laststatus')

      if
        vim.g._fzf_leave_win
        and vim.api.nvim_win_is_valid(vim.g._fzf_leave_win)
        and vim.api.nvim_get_current_win() ~= vim.g._fzf_leave_win
      then
        vim.api.nvim_set_current_win(vim.g._fzf_leave_win)
      end
      vim.g._fzf_leave_win = nil

      if vim.go.lines == vim.g._fzf_vim_lines then
        utils.win.restheights()
      end
      vim.g._fzf_vim_lines = nil
      utils.win.clearheights()
      utils.win.restviews()
      utils.win.clearviews()
    end,
    preview = {
      hidden = 'hidden',
    },
  },
  fzf_opts = {
    ['--no-scrollbar'] = '',
    ['--no-separator'] = '',
    ['--info'] = 'inline-right',
    ['--layout'] = 'default',
    ['--marker'] = '+',
    ['--prompt'] = '/ ',
    ['--border'] = 'none',
    ['--padding'] = '0,1',
    ['--margin'] = '0',
    ['--no-preview'] = '',
    ['--preview-window'] = 'hidden',
  },
  keymap = {
    -- Overrides default completion completely
    builtin = {
      ['<F1>'] = 'toggle-help',
      ['<F2>'] = 'toggle-fullscreen',
    },
    fzf = {
      -- fzf '--bind=' options
      ['ctrl-z'] = 'abort',
      ['ctrl-k'] = 'kill-line',
      ['ctrl-u'] = 'unix-line-discard',
      ['ctrl-a'] = 'beginning-of-line',
      ['ctrl-e'] = 'end-of-line',
      ['alt-a'] = 'toggle-all',
      ['alt-}'] = 'last',
      ['alt-{'] = 'first',
    },
  },
  actions = {
    files = {
      ['alt-s'] = actions.file_split,
      ['alt-v'] = actions.file_vsplit,
      ['alt-t'] = actions.file_tabedit,
      ['alt-q'] = actions._file_sel_to_qf,
      ['alt-o'] = actions._file_sel_to_ll,
      ['default'] = actions._file_edit_or_qf,
    },
    buffers = {
      ['default'] = actions.buf_edit,
      ['alt-s'] = actions.buf_split,
      ['alt-v'] = actions.buf_vsplit,
      ['alt-t'] = actions.buf_tabedit,
    },
  },
  defaults = {
    headers = {},
    git_icons = false,
    file_icons = false,
    actions = {
      ['ctrl-]'] = actions.switch_provider,
    },
  },
  args = {
    files_only = false,
    actions = {
      ['ctrl-s'] = actions.arg_search_add,
      ['ctrl-x'] = {
        fn = actions.arg_del,
        reload = true,
      },
    },
  },
  autocmds = {
    actions = {
      ['ctrl-x'] = {
        fn = actions.del_autocmd,
        -- reload = true,
      },
    },
  },
  blines = {
    actions = {
      ['alt-q'] = actions.buf_sel_to_qf,
      ['alt-o'] = actions.buf_sel_to_ll,
      ['alt-l'] = false,
    },
  },
  lines = {
    actions = {
      ['alt-q'] = actions.buf_sel_to_qf,
      ['alt-o'] = actions.buf_sel_to_ll,
      ['alt-l'] = false,
    },
  },
  buffers = {
    show_unlisted = true,
    show_unloaded = true,
    ignore_current_buffer = false,
    no_action_set_cursor = true,
    current_tab_only = false,
    no_term_buffers = false,
    cwd_only = false,
    ls_cmd = 'ls',
  },
  helptags = {
    actions = {
      ['default'] = actions.help,
      ['alt-s'] = actions.help,
      ['alt-v'] = actions.help_vert,
      ['alt-t'] = actions.help_tab,
    },
  },
  manpages = {
    actions = {
      ['default'] = actions.man,
      ['alt-s'] = actions.man,
      ['alt-v'] = actions.man_vert,
      ['alt-t'] = actions.man_tab,
    },
  },
  keymaps = {
    actions = {
      ['default'] = actions.keymap_edit,
      ['alt-s'] = actions.keymap_split,
      ['alt-v'] = actions.keymap_vsplit,
      ['alt-t'] = actions.keymap_tabedit,
    },
  },
  colorschemes = {
    actions = {
      ['default'] = actions.colorscheme,
    },
  },
  highlights = {
    actions = {
      ['default'] = function(selected)
        vim.defer_fn(function()
          vim.cmd.hi(selected[1])
        end, 0)
      end,
    },
  },
  command_history = {
    actions = {
      ['alt-e'] = actions.ex_run,
      ['ctrl-e'] = false,
    },
  },
  search_history = {
    actions = {
      ['alt-e'] = actions.search,
      ['ctrl-e'] = false,
    },
  },
  files = {
    actions = {
      ['alt-c'] = actions.switch_cwd,
      ['ctrl-g'] = actions.toggle_ignore,
    },
    find_opts = [[-type f -type d -type l -not -path '*/\.git/*' -printf '%P\n']],
    fd_opts = [[--color=never --type f --type d --type l --hidden --follow --exclude .git]],
    rg_opts = [[--color=never --files --hidden --follow -g '!.git'"]],
  },
  oldfiles = {
    prompt = 'Oldfiles> ',
  },
  grep = {
    actions = {
      ['alt-c'] = actions.switch_cwd,
    },
    rg_opts = table.concat({
      '--hidden',
      '--follow',
      '--smart-case',
      '--column',
      '--line-number',
      '--no-heading',
      '--color=always',
      '-g=!.git/',
      '-e',
    }, ' '),
  },
  lsp = {
    finder = {
      fzf_opts = {
        ['--info'] = 'inline-right',
      },
    },
    definitions = {
      sync = false,
      jump_to_single_result = true,
    },
    references = {
      sync = false,
      ignore_current_line = true,
      jump_to_single_result = true,
    },
    typedefs = {
      sync = false,
      jump_to_single_result = true,
    },
    symbols = {
      symbol_icons = vim.tbl_map(vim.trim, icons.kinds),
    },
  },
})

-- stylua: ignore start
vim.keymap.set('n', '<Leader>.', fzf.files, { desc = 'Find files' })
vim.keymap.set('n', "<Leader>'", fzf.resume, { desc = 'Resume last picker' })
vim.keymap.set('n', "<Leader>`", fzf.marks, { desc = 'Find marks' })
vim.keymap.set('n', '<Leader>,', fzf.buffers, { desc = 'Find buffers' })
vim.keymap.set('n', '<Leader>%', fzf.tabs, { desc = 'Find tabpages' })
vim.keymap.set('n', '<Leader>/', fzf.live_grep, { desc = 'Grep' })
vim.keymap.set('n', '<Leader>?', fzf.help_tags, { desc = 'Find help tags' })
vim.keymap.set('n', '<Leader>*', fzf.grep_cword, { desc = 'Grep word under cursor' })
vim.keymap.set('x', '<Leader>*', fzf.grep_visual, { desc = 'Grep visual selection' })
vim.keymap.set('n', '<Leader>#', fzf.grep_cword, { desc = 'Grep word under cursor' })
vim.keymap.set('x', '<Leader>#', fzf.grep_visual, { desc = 'Grep visual selection' })
vim.keymap.set('n', '<Leader>"', fzf.registers, { desc = 'Find registers' })
vim.keymap.set('n', '<Leader>:', fzf.commands, { desc = 'Find commands' })
vim.keymap.set('n', '<Leader>F', fzf.builtin, { desc = 'Find all available pickers' })
vim.keymap.set('n', '<Leader>o', fzf.oldfiles, { desc = 'Find old files' })
vim.keymap.set('n', '<Leader>-', fzf.blines, { desc = 'Find lines in buffer' })
vim.keymap.set('n', '<Leader>=', fzf.lines, { desc = 'Find lines across buffers' })
vim.keymap.set('x', '<Leader>-', fzf.blines, { desc = 'Find lines in selection' })
vim.keymap.set('x', '<Leader>=', fzf.blines, { desc = 'Find lines in selection' })
vim.keymap.set('n', '<Leader>n', fzf.treesitter, { desc = 'Find treesitter nodes' })
vim.keymap.set('n', '<Leader>R', fzf.lsp_finder, { desc = 'Find symbol locations' })
vim.keymap.set('n', '<Leader>f"', fzf.registers, { desc = 'Find registers' })
vim.keymap.set('n', '<Leader>f*', fzf.grep_cword, { desc = 'Grep word under cursor' })
vim.keymap.set('x', '<Leader>f*', fzf.grep_visual, { desc = 'Grep visual selection' })
vim.keymap.set('n', '<Leader>f#', fzf.grep_cword, { desc = 'Grep word under cursor' })
vim.keymap.set('x', '<Leader>f#', fzf.grep_visual, { desc = 'Grep visual selection' })
vim.keymap.set('n', '<Leader>f:', fzf.commands, { desc = 'Find commands' })
vim.keymap.set('n', '<Leader>f/', fzf.live_grep, { desc = 'Grep' })
vim.keymap.set('n', '<Leader>fH', fzf.highlights, { desc = 'Find highlights' })
vim.keymap.set('n', "<Leader>f'", fzf.resume, { desc = 'Resume last picker' })
vim.keymap.set('n', '<Leader>fA', fzf.autocmds, { desc = 'Find autocommands' })
vim.keymap.set('n', '<Leader>fb', fzf.buffers, { desc = 'Find buffers' })
vim.keymap.set('n', '<Leader>fp', fzf.tabs, { desc = 'Find tabpages' })
vim.keymap.set('n', '<Leader>ft', fzf.tags, { desc = 'Find tags' })
vim.keymap.set('n', '<Leader>fc', fzf.changes, { desc = 'Find changes' })
vim.keymap.set('n', '<Leader>fd', fzf.diagnostics_document, { desc = 'Find document diagnostics' })
vim.keymap.set('n', '<Leader>fD', fzf.diagnostics_workspace, { desc = 'Find workspace diagnostics' })
vim.keymap.set('n', '<Leader>ff', fzf.files, { desc = 'Find files' })
vim.keymap.set('n', '<Leader>fa', fzf.args, { desc = 'Find args' })
vim.keymap.set('n', '<Leader>fl', fzf.loclist, { desc = 'Find location list' })
vim.keymap.set('n', '<Leader>fq', fzf.quickfix, { desc = 'Find quickfix list' })
vim.keymap.set('n', '<Leader>fL', fzf.loclist_stack, { desc = 'Find location list stack' })
vim.keymap.set('n', '<Leader>fQ', fzf.quickfix_stack, { desc = 'Find quickfix stack' })
vim.keymap.set('n', '<Leader>fgt', fzf.git_tags, { desc = 'Find git tags' })
vim.keymap.set('n', '<Leader>fgs', fzf.git_stash, { desc = 'Find git stash' })
vim.keymap.set('n', '<Leader>fgg', fzf.git_status, { desc = 'Find git status' })
vim.keymap.set('n', '<Leader>fgL', fzf.git_commits, { desc = 'Find git logs' })
vim.keymap.set('n', '<Leader>fgl', fzf.git_bcommits, { desc = 'Find git buffer logs' })
vim.keymap.set('n', '<Leader>fgb', fzf.git_branches, { desc = 'Find git branches' })
vim.keymap.set('n', '<Leader>fgB', fzf.git_blame, { desc = 'Find git blame' })
vim.keymap.set('n', '<Leader>gft', fzf.git_tags, { desc = 'Find git tags' })
vim.keymap.set('n', '<Leader>gfs', fzf.git_stash, { desc = 'Find git stash' })
vim.keymap.set('n', '<Leader>gfg', fzf.git_status, { desc = 'Find git status' })
vim.keymap.set('n', '<Leader>gfL', fzf.git_commits, { desc = 'Find git logs' })
vim.keymap.set('n', '<Leader>gfl', fzf.git_bcommits, { desc = 'Find git buffer logs' })
vim.keymap.set('n', '<Leader>gfb', fzf.git_branches, { desc = 'Find git branches' })
vim.keymap.set('n', '<Leader>gfB', fzf.git_blame, { desc = 'Find git blame' })
vim.keymap.set('n', '<Leader>fh', fzf.help_tags, { desc = 'Find help tags' })
vim.keymap.set('n', '<Leader>fk', fzf.keymaps, { desc = 'Find keymaps' })
vim.keymap.set('n', '<Leader>f-', fzf.blines, { desc = 'Find lines in buffer' })
vim.keymap.set('x', '<Leader>f-', fzf.blines, { desc = 'Find lines in selection' })
vim.keymap.set('n', '<Leader>f=', fzf.lines, { desc = 'Find lines across buffers' })
vim.keymap.set('n', '<Leader>fm', fzf.marks, { desc = 'Find marks' })
vim.keymap.set('n', '<Leader>fo', fzf.oldfiles, { desc = 'Find old files' })
vim.keymap.set('n', '<Leader>fSa', fzf.lsp_code_actions, { desc = 'Find code actions' })
vim.keymap.set('n', '<Leader>fSd', fzf.lsp_definitions, { desc = 'Find symbol definitions' })
vim.keymap.set('n', '<Leader>fSD', fzf.lsp_declarations, { desc = 'Find symbol declarations' })
vim.keymap.set('n', '<Leader>fS<C-d>', fzf.lsp_typedefs, { desc = 'Find symbol type definitions' })
vim.keymap.set('n', '<Leader>fSs', fzf.lsp_document_symbols, { desc = 'Find document symbols' })
vim.keymap.set('n', '<Leader>fSS', fzf.lsp_live_workspace_symbols, { desc = 'Find workspace symbols' })
vim.keymap.set('n', '<Leader>fSi', fzf.lsp_implementations, { desc = 'Find symbol implementations' })
vim.keymap.set('n', '<Leader>fS<', fzf.lsp_incoming_calls, { desc = 'Find symbol incoming calls' })
vim.keymap.set('n', '<Leader>fS>', fzf.lsp_outgoing_calls, { desc = 'Find symbol outgoing calls' })
vim.keymap.set('n', '<Leader>fSr', fzf.lsp_references, { desc = 'Find symbol references' })
vim.keymap.set('n', '<Leader>fSR', fzf.lsp_finder, { desc = 'Find symbol locations' })
vim.keymap.set('n', '<Leader>fF', fzf.builtin, { desc = 'Find all available pickers' })
vim.keymap.set('n', '<Leader>f<Esc>', '<Nop>', { desc = 'Cancel' })
-- stylua: ignore end

local _lsp_workspace_symbol = vim.lsp.buf.workspace_symbol

---Overriding `vim.lsp.buf.workspace_symbol()`, not only the handler here
---to skip the 'Query:' input prompt -- with `fzf.lsp_live_workspace_symbols()`
---as handler we can update the query in live
---@diagnostic disable-next-line: duplicate-set-field
function vim.lsp.buf.workspace_symbol(query, options)
  _lsp_workspace_symbol(query or '', options)
end

vim.lsp.handlers['callHierarchy/incomingCalls'] = fzf.lsp_incoming_calls
vim.lsp.handlers['callHierarchy/outgoingCalls'] = fzf.lsp_outgoing_calls
vim.lsp.handlers['textDocument/codeAction'] = fzf.code_actions
vim.lsp.handlers['textDocument/declaration'] = fzf.declarations
vim.lsp.handlers['textDocument/definition'] = fzf.lsp_definitions
vim.lsp.handlers['textDocument/documentSymbol'] = fzf.lsp_document_symbols
vim.lsp.handlers['textDocument/implementation'] = fzf.lsp_implementations
vim.lsp.handlers['textDocument/references'] = fzf.lsp_references
vim.lsp.handlers['textDocument/typeDefinition'] = fzf.lsp_typedefs
vim.lsp.handlers['workspace/symbol'] = fzf.lsp_live_workspace_symbols

vim.diagnostic.setqflist = fzf.diagnostics_workspace
vim.diagnostic.setloclist = fzf.diagnostics_document
