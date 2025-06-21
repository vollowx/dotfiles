local autocmd = vim.api.nvim_create_autocmd
local groupid = vim.api.nvim_create_augroup

---@param group string
---@vararg { [1]: string|string[], [2]: vim.api.keyset.create_autocmd }
---@return nil
local function augroup(group, ...)
  local id = groupid(group, {})
  for _, a in ipairs({ ... }) do
    a[2].group = id
    autocmd(unpack(a))
  end
end

augroup('BigFileSettings', {
  'BufReadPre',
  {
    desc = 'Set settings for large files.',
    callback = function(info)
      vim.b.bigfile = false
      local stat = vim.uv.fs_stat(info.match)
      if stat and stat.size > 524288 then
        vim.b.bigfile = true
        vim.opt_local.spell = false
        vim.opt_local.swapfile = false
        vim.opt_local.undofile = false
        vim.opt_local.breakindent = false
        vim.opt_local.colorcolumn = ''
        vim.opt_local.statuscolumn = ''
        vim.opt_local.signcolumn = 'no'
        vim.opt_local.foldcolumn = '0'
        vim.opt_local.winbar = ''
        vim.cmd.syntax('off')
      end
    end,
  },
})

augroup('YankHighlight', {
  'TextYankPost',
  {
    desc = 'Highlight the selection on yank.',
    callback = function()
      vim.highlight.on_yank({ higroup = 'Visual', timeout = 200 })
    end,
  },
})

augroup('WinCloseJmp', {
  'WinClosed',
  {
    nested = true,
    desc = 'Jump to last accessed window on closing the current one.',
    command = "if expand('<amatch>') == win_getid() | wincmd p | endif",
  },
})

augroup('LastPosJmp', {
  'BufReadPost',
  {
    desc = 'Last position jump.',
    callback = function(info)
      local ft = vim.bo[info.buf].ft
      -- don't apply to git messages
      if ft ~= 'gitcommit' and ft ~= 'gitrebase' then
        vim.cmd.normal({
          'g`"zvzz',
          bang = true,
          mods = { emsg_silent = true },
        })
      end
    end,
  },
})

augroup('AutoCwd', {
  { 'BufWinEnter', 'FileChangedShellPost' },
  {
    pattern = '*',
    desc = 'Automatically change local current directory.',
    callback = function(info)
      if info.file == '' or vim.bo[info.buf].bt ~= '' then
        return
      end
      local buf = info.buf
      local win = vim.api.nvim_get_current_win()

      vim.schedule(function()
        if
          not vim.api.nvim_buf_is_valid(buf)
          or not vim.api.nvim_win_is_valid(win)
          or not vim.api.nvim_win_get_buf(win) == buf
        then
          return
        end
        vim.api.nvim_win_call(win, function()
          local current_dir = vim.fn.getcwd(0)
          local target_dir = require('utils').fs.proj_dir(info.file)
            or vim.fs.dirname(info.file)
          local stat = target_dir and vim.uv.fs_stat(target_dir)
          -- Prevent unnecessary directory change, which triggers
          -- DirChanged autocmds that may update winbar unexpectedly
          if
            stat
            and stat.type == 'directory'
            and current_dir ~= target_dir
          then
            pcall(vim.cmd.lcd, target_dir)
          end
        end)
      end)
    end,
  },
})

augroup('PromptBufKeymaps', {
  'BufEnter',
  {
    desc = 'Undo automatic <C-w> remap in prompt buffers.',
    callback = function(info)
      if vim.bo[info.buf].buftype == 'prompt' then
        vim.keymap.set('i', '<C-w>', '<C-S-W>', { buffer = info.buf })
      end
    end,
  },
})

augroup('KeepWinRatio', {
  { 'VimResized', 'TabEnter' },
  {
    desc = 'Keep window ratio after resizing nvim.',
    callback = function()
      vim.cmd.wincmd('=')
    end,
  },
})

augroup('AutoHlCursorLine', {
  'WinEnter',
  {
    desc = 'Show cursorline and cursorcolumn in current window.',
    callback = function()
      if vim.w._cul and not vim.wo.cul then
        vim.wo.cul = true
        vim.w._cul = nil
      end
      if vim.w._cuc and not vim.wo.cuc then
        vim.wo.cuc = true
        vim.w._cuc = nil
      end

      local prev_win = vim.fn.win_getid(vim.fn.winnr('#'))
      if prev_win ~= 0 then
        local w = vim.w[prev_win]
        local wo = vim.wo[prev_win]
        w._cul = wo.cul
        w._cuc = wo.cuc
        wo.cul = false
        wo.cuc = false
      end
    end,
  },
})

augroup('AutoCreateDir', {
  'BufWritePre',
  {
    desc = 'Auto create directory when not exist.',
    callback = function(info)
      if info.match:match('^%w%w+://') then
        return
      end
      local file = vim.uv.fs_realpath(info.match) or info.match
      vim.fn.mkdir(vim.fn.fnamemodify(file, ':p:h'), 'p')
    end,
  },
})

augroup('LazyLoadSpell', {
  'BufWinEnter',
  {
    desc = 'Lazy-load spell check',
    callback = function()
      vim.opt.spell = true
      vim.opt.spellcapcheck = ''
      vim.opt.spelllang = 'en,cjk'
      vim.opt.spelloptions = 'camel'
      vim.opt.spellsuggest = 'best,9'
    end,
  },
})

augroup('StatusColumn', {
  { 'BufWritePost', 'BufWinEnter' },
  {
    desc = 'Init statuscolumn plugin.',
    once = true,
    callback = function()
      require('core._internal.statuscolumn').setup()
      return true
    end,
  },
})

augroup('TerminalSettings', {
  'TermOpen',
  {
    desc = 'Set terminal settings.',
    callback = function(info)
      require('core._internal.terminal').setup(info.buf)
    end,
  },
})

augroup('LspSettings', {
  'LspAttach',
  {
    desc = 'Set LSP settings.',
    once = true,
    callback = function()
      require('core._internal.lsp').setup()
    end,
  },
}, {
  'LspAttach',
  {
    desc = 'Set LSP per buffer settings.',
    callback = function(info)
      vim.lsp.inlay_hint.enable(true, { bufnr = info.buf })
    end,
  },
})
