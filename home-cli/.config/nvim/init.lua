-- vim: fdm=marker fdl=0

vim.loader.enable()
require('vim._core.ui2').enable({ enable = true })

-- global variables {{{1
vim.g.has_ui = #vim.api.nvim_list_uis() > 0
vim.g.has_gui = vim.g.has_ui
  and (
    vim.env.DISPLAY ~= nil
    or vim.env.WAYLAND_DISPLAY ~= nil
    or vim.env.WSL_DISTRO_NAME ~= nil
  )
-- }}}1

-- helpers {{{1
local o = vim.opt
local g = vim.g
local map = vim.keymap.set
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
-- }}}1

-- options {{{1
-- stylua: ignore start
o.autowriteall   = true
o.cursorline     = true
o.cursorlineopt  = 'number'
o.foldlevelstart = 99
o.foldtext       = ''
o.grepprg        = 'rg --vimgrep -uu'
o.helpheight     = 10
o.relativenumber = true
o.pumheight      = 16
o.scrolloff      = 4
o.sidescrolloff  = 8
o.showcmd        = false
o.showmode       = false
o.signcolumn     = 'yes:1'
o.splitright     = true
o.splitbelow     = true
o.splitkeep      = 'screen'
o.swapfile       = false
o.undofile       = true
o.updatetime     = 100
o.wrap           = false
o.linebreak      = true
o.smoothscroll   = true
o.ignorecase     = true
o.smartcase      = true
o.conceallevel   = 2
o.tabstop        = 2
o.softtabstop    = 2
o.shiftwidth     = 2
o.breakindent    = true
o.smartindent    = true
o.expandtab      = true
o.virtualedit    = 'block'
o.completeopt    = 'menuone,noinsert,popup'
o.jumpoptions    = 'stack,view'
-- stylua: ignore end

o.backup = true
o.backupdir:remove('.')

o.clipboard:append('unnamedplus')

o.diffopt:append({
  'algorithm:histogram',
  'indent-heuristic',
})

o.gcr = {
  'i-c-ci-ve:blinkoff500-blinkon500-block-TermCursor',
  'n-v:block-Curosr/lCursor',
  'o:hor50-Curosr/lCursor',
  'r-cr:hor20-Curosr/lCursor',
}

o.list = true
o.listchars = {
  tab = '→ ',
  trail = '·',
}
o.fillchars = {
  fold = ' ',
  foldsep = ' ',
  eob = ' ',
}

if g.has_gui then
  o.listchars:append({ nbsp = '·' })
  o.fillchars:append({
    foldopen = '',
    foldclose = '',
    diff = '╱',
  })
end

o.shortmess:append('I')
o.shortmess:remove('l')

-- Netrw settings
g.netrw_banner = 0
g.netrw_cursor = 5
g.netrw_keepdir = 0
g.netrw_keepj = ''
g.netrw_list_hide = [[\(^\|\s\s\)\zs\.\S\+]]
g.netrw_liststyle = 1
g.netrw_localcopydircmd = 'cp -r'

-- stylua: ignore start
g.loaded_gzip              = 0
g.loaded_tar               = 0
g.loaded_tarPlugin         = 0
g.loaded_zip               = 0
g.loaded_zipPlugin         = 0
-- stylua: ignore end
-- }}}1

-- key-mappings {{{1
g.mapleader = ' '
g.maplocalleader = ' '

map('n', 'q', '<Cmd>fclose<CR>', { desc = 'Close all floating windows' })
map({ 'n', 'x' }, '-', '<Cmd>e%:p:h<CR>', { desc = 'Edit parent directory' })
map('x', '/', '<Esc>/\\%V', { desc = 'Search within Visual selection' })

-- Insert at the beginning/end of the first line in line Visual mode
map('x', 'I', function()
  return vim.fn.mode() == 'V' and '^<C-v>I' or 'I'
end, { expr = true })
map('x', 'A', function()
  return vim.fn.mode() == 'V' and '$<C-v>A' or 'A'
end, { expr = true })

-- Map space to wildcard in search mode
map('c', '<Space>', function()
  if vim.fn.getcmdtype():match('[/?]') then
    return '.\\{-}'
  else
    return '<Space>'
  end
end, { expr = true })

-- More consistent behavior of j/k when &wrap is set
-- stylua: ignore start
map({ 'n', 'x' }, 'j', 'v:count ? "j" : "gj"', { expr = true })
map({ 'n', 'x' }, 'k', 'v:count ? "k" : "gk"', { expr = true })
map({ 'n', 'x' }, '<Down>', 'v:count ? "<Down>" : "g<Down>"', { expr = true, replace_keycodes = false })
map({ 'n', 'x' }, '<Up>',   'v:count ? "<Up>"   : "g<Up>"',   { expr = true, replace_keycodes = false })
map({ 'i' }, '<Down>', '<Cmd>norm! g<Down><CR>')
map({ 'i' }, '<Up>',   '<Cmd>norm! g<Up><CR>')
-- stylua: ignore end

-- Buffer navigation
map('n', ']b', '<Cmd>exec v:count1 . "bn"<CR>')
map('n', '[b', '<Cmd>exec v:count1 . "bp"<CR>')
map('n', '<Leader>x', function()
  local cur_buf = vim.api.nvim_get_current_buf()
  local all_bufs = vim.fn.getbufinfo({ buflisted = 1 })

  local replacement = nil
  for _, buf in ipairs(all_bufs) do
    if buf.bufnr ~= cur_buf then
      replacement = buf.bufnr
      break
    end
  end

  if not replacement then
    replacement = vim.api.nvim_create_buf(false, true)
  end

  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_get_buf(win) == cur_buf then
      vim.api.nvim_win_set_buf(win, replacement)
    end
  end

  vim.cmd('confirm bwipeout ' .. cur_buf)
end, { desc = 'Close current buffer' })
-- }}}1

-- autocmds {{{1
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
      -- Exclude git messages
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
          local target_dir = require('my.utils.fs').root(info.file)
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

augroup('KeepWinRatio', {
  { 'VimResized', 'TabEnter' },
  {
    desc = 'Keep window ratio after resizing nvim.',
    callback = function()
      vim.cmd.wincmd('=')
    end,
  },
})
-- }}}1

require('my.core.terminal')
require('my.core.treesitter')
require('my.core.lsp')
require('my.core.diagnostic')

require('my.utils.pack').source('@/lua/my/specs')
require('my.utils.pack').ensure()

if vim.g.has_gui and vim.g.has_ui then
  vim.cmd.colorscheme('modus')
end
