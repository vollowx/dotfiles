-- vim: fdm=marker

---@diagnostic disable-next-line: duplicate-set-field
vim.validate = function() end
vim.loader.enable()
require('vim._core.ui2').enable({enable = true})

-- global variables {{{1
vim.g.has_ui = #vim.api.nvim_list_uis() > 0
vim.g.has_gui = vim.g.has_ui
  and (
    vim.env.DISPLAY ~= nil
    or vim.env.WAYLAND_DISPLAY ~= nil
    or vim.env.WSL_DISTRO_NAME ~= nil
  )
-- }}}1

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

-- options {{{1

-- stylua: ignore start
o.cursorline     = true
o.cursorlineopt  = 'number'
o.autowriteall   = true
o.foldcolumn     = '0'
o.foldlevelstart = 99
o.foldtext       = ''
o.helpheight     = 10
o.mousemoveevent = true
o.number         = true
o.relativenumber = true
o.ruler          = true
o.pumheight      = 16
o.scrolloff      = 4
o.sidescrolloff  = 8
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
g.loaded_2html_plugin      = 0
g.loaded_gzip              = 0
g.loaded_tar               = 0
g.loaded_tarPlugin         = 0
g.loaded_tutor_mode_plugin = 0
g.loaded_zip               = 0
g.loaded_zipPlugin         = 0
-- stylua: ignore end

g.qf_disable_statusline = 1
o.grepprg = 'rg --vimgrep -uu'

-- o.tabline = "%!v:lua.require'my.tabline'()"
o.statusline = "%!v:lua.require'my.statusline'()"
-- o.statuscolumn = "%!v:lua.require'my.statuscolumn'()"

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

-- More consistent behavior of j/k when &wrap is set
-- stylua: ignore start
map({ 'n', 'x' }, 'j', 'v:count ? "j" : "gj"', { expr = true })
map({ 'n', 'x' }, 'k', 'v:count ? "k" : "gk"', { expr = true })
map({ 'n', 'x' }, '<Down>', 'v:count ? "<Down>" : "g<Down>"', { expr = true, replace_keycodes = false })
map({ 'n', 'x' }, '<Up>',   'v:count ? "<Up>"   : "g<Up>"',   { expr = true, replace_keycodes = false })
map({ 'i' }, '<Down>', '<Cmd>norm! g<Down><CR>')
map({ 'i' }, '<Up>',   '<Cmd>norm! g<Up><CR>')
-- stylua: ignore end

-- Multi-window operations
-- stylua: ignore start
map({ 'x', 'n' }, '<M-w>', '<C-w>w', { desc = 'Cycle through windows' })
map({ 'x', 'n' }, '<M-W>', '<C-w>W', { desc = 'Cycle through windows reversely' })
map({ 'x', 'n' }, '<M-H>', '<C-w>H', { desc = 'Move window to far left' })
map({ 'x', 'n' }, '<M-J>', '<C-w>J', { desc = 'Move winow to very bottom' })
map({ 'x', 'n' }, '<M-K>', '<C-w>K', { desc = 'Move window to very top' })
map({ 'x', 'n' }, '<M-L>', '<C-w>L', { desc = 'Move window to far right' })
map({ 'x', 'n' }, '<M-p>', '<C-w>p', { desc = 'Go to the previous window' })
map({ 'x', 'n' }, '<M-r>', '<C-w>r', { desc = 'Rotate windows downwords/rightwards' })
map({ 'x', 'n' }, '<M-R>', '<C-w>r', { desc = 'Rotate windows upwards/leftwords' })
map({ 'x', 'n' }, '<M-v>', '<C-w>v', { desc = 'Split window vertically' })
map({ 'x', 'n' }, '<M-s>', '<C-w>s', { desc = 'Split window horizontally' })
map({ 'x', 'n' }, '<M-x>', '<C-w>x', { desc = 'Exchange current window with next one' })
map({ 'x', 'n' }, '<M-z>', '<C-w>z', { desc = 'Close preview window' })
map({ 'x', 'n' }, '<M-c>', '<C-w>c', { desc = 'Close current window' })
map({ 'x', 'n' }, '<M-q>', '<C-w>q', { desc = 'Quit current window' })
map({ 'x', 'n' }, '<M-n>', '<C-w>n', { desc = 'Create new window' })
map({ 'x', 'n' }, '<M-o>', '<C-w>o', { desc = 'Make current window the only one' })
map({ 'x', 'n' }, '<M-t>', '<C-w>t', { desc = 'Go to the top-left window' })
map({ 'x', 'n' }, '<M-T>', '<C-w>T', { desc = 'Move window to new tab' })
map({ 'x', 'n' }, '<M-]>', '<C-w>]', { desc = 'Split and jump to tag under cursor' })
map({ 'x', 'n' }, '<M-^>', '<C-w>^', { desc = 'Split and edit alternate file' })
map({ 'x', 'n' }, '<M-b>', '<C-w>b', { desc = 'Go to the bottom-right window' })
map({ 'x', 'n' }, '<M-d>', '<C-w>d', { desc = 'Split and jump to definition' })
map({ 'x', 'n' }, '<M-f>', '<C-w>f', { desc = 'Split and edit file under cursor' })
map({ 'x', 'n' }, '<M-}>', '<C-w>}', { desc = 'Show tag under cursor in preview window' })
map({ 'x', 'n' }, '<M-g>]', '<C-w>g]', { desc = 'Split and select tag under cursor' })
map({ 'x', 'n' }, '<M-g>}', '<C-w>g}', { desc = 'Show tag under cursor in preview window' })
map({ 'x', 'n' }, '<M-g>f', '<C-w>gf', { desc = 'Edit file under cursor in new tab' })
map({ 'x', 'n' }, '<M-g>F', '<C-w>gF', { desc = 'Edit file under cursor in new tab and jump to line' })
map({ 'x', 'n' }, '<M-g>t', '<C-w>gt', { desc = 'Go to next tab' })
map({ 'x', 'n' }, '<M-g>T', '<C-w>gT', { desc = 'Go to previous tab' })
map({ 'x', 'n' }, '<M-h>', '<C-w><C-h>', { desc = 'Go to the left window' })
map({ 'x', 'n' }, '<M-j>', '<C-w><C-j>', { desc = 'Go to the window below' })
map({ 'x', 'n' }, '<M-k>', '<C-w><C-k>', { desc = 'Go to the window above' })
map({ 'x', 'n' }, '<M-l>', '<C-w><C-l>', { desc = 'Go to the right window' })
map({ 'x', 'n' }, '<M-Left>', '<C-w><Left>', { desc = 'Go to the left window' })
map({ 'x', 'n' }, '<M-Down>', '<C-w><Down>', { desc = 'Go to the window below' })
map({ 'x', 'n' }, '<M-Up>', '<C-w><Up>', { desc = 'Go to the window above' })
map({ 'x', 'n' }, '<M-Right>', '<C-w><Right>', { desc = 'Go to the right window' })
map({ 'x', 'n' }, '<M-g><M-]>', '<C-w>g<C-]>', { desc = 'Split and jump to tag under cursor' })
map({ 'x', 'n' }, '<M-g><Tab>', '<C-w>g<Tab>', { desc = 'Go to last accessed tab' })

map({ 'x', 'n' }, '<M-=>', '<C-w>=', { desc = 'Make all windows equal size' })
map({ 'x', 'n' }, '<M-_>', '<C-w>_', { desc = 'Set current window height to maximum' })
map({ 'x', 'n' }, '<M-|>', '<C-w>|', { desc = 'Set current window width to maximum' })
map({ 'x', 'n' }, '<M-+>', 'v:count ? "<C-w>+" : "2<C-w>+"', { expr = true, desc = 'Increase window height' })
map({ 'x', 'n' }, '<M-->', 'v:count ? "<C-w>-" : "2<C-w>-"', { expr = true, desc = 'Decrease window height' })
map({ 'x', 'n' }, '<M->>', 'v:count ? "<C-w>>" : "2<C-w>>"', { expr = true, desc = 'Resize window right' })
map({ 'x', 'n' }, '<M-.>', 'v:count ? "<C-w>>" : "2<C-w>>"', { expr = true, desc = 'Resize window right' })
map({ 'x', 'n' }, '<M-<>', 'v:count ? "<C-w><" : "2<C-w><"', { expr = true, desc = 'Resize window left' })
map({ 'x', 'n' }, '<M-,>', 'v:count ? "<C-w><" : "2<C-w><"', { expr = true, desc = 'Resize window left' })

map({ 'x', 'n' }, '<C-w>>', 'v:count ? "<C-w>>" : "2<C-w>>"', { expr = true, desc = 'Resize window right' })
map({ 'x', 'n' }, '<C-w>.', 'v:count ? "<C-w>>" : "2<C-w>>"', { expr = true, desc = 'Resize window right' })
map({ 'x', 'n' }, '<C-w><', 'v:count ? "<C-w><" : "2<C-w><"', { expr = true, desc = 'Resize window left' })
map({ 'x', 'n' }, '<C-w>,', 'v:count ? "<C-w><" : "2<C-w><"', { expr = true, desc = 'Resize window left' })
map({ 'x', 'n' }, '<C-w>+', 'v:count ? "<C-w>+" : "2<C-w>+"', { expr = true, desc = 'Increase window height' })
map({ 'x', 'n' }, '<C-w>-', 'v:count ? "<C-w>-" : "2<C-w>-"', { expr = true, desc = 'Decrease window height' })

map('t', '<C-^>', '<Cmd>b#<CR>',       { replace_keycodes = false })
map('t', '<C-6>', '<Cmd>b#<CR>',       { replace_keycodes = false })
map('t', '<Esc>', '<Cmd>stopi<CR>',    { replace_keycodes = false })
map('t', '<M-h>', '<Cmd>wincmd h<CR>', { replace_keycodes = false })
map('t', '<M-j>', '<Cmd>wincmd j<CR>', { replace_keycodes = false })
map('t', '<M-k>', '<Cmd>wincmd k<CR>', { replace_keycodes = false })
map('t', '<M-l>', '<Cmd>wincmd l<CR>', { replace_keycodes = false })
-- stylua: ignore end

-- Buffer navigation
map('n', ']b', '<Cmd>exec v:count1 . "bn"<CR>')
map('n', '[b', '<Cmd>exec v:count1 . "bp"<CR>')
map('n', '<Leader>x', function()
  local bufnr = vim.fn.bufnr('%')
  local num_bufs = #vim.api.nvim_list_bufs()
  if num_bufs == 0 then
    return
  end
  if num_bufs == 1 then
    vim.cmd('new')
    vim.cmd('windo bp')
  else
    vim.cmd('windo if bufnr() == ' .. bufnr .. '|bp|endif')
  end
  vim.cmd('bwipeout ' .. bufnr)
end, { desc = 'Close current buffer' })

-- Correct misspelled word / mark as correct
map('i', '<C-g>+', '<Esc>[szg`]a')
map('i', '<C-g>=', '<C-g>u<Esc>[s1z=`]a<C-G>u')

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
          local target_dir = require('my.utils').fs.root(info.file)
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

augroup('AutoCreateDir', {
  'BufWritePre',
  {
    desc = 'Auto create directory when does not exist.',
    callback = function(info)
      if info.match:match('^%w%w+://') then
        return
      end
      local file = vim.uv.fs_realpath(info.match) or info.match
      vim.fn.mkdir(vim.fn.fnamemodify(file, ':p:h'), 'p')
    end,
  },
})

augroup('TerminalSettings', {
  'TermOpen',
  {
    desc = 'Set terminal settings.',
    callback = function(info)
      require('my.terminal').setup(info.buf)
    end,
  },
})

augroup('TmuxSupport', {
  'UIEnter',
  {
    desc = 'Load tmux support.',
    callback = function()
      require('my.tmux').setup()
    end,
  },
})

-- }}}1

require('my.pack').source('@/lua/my/specs')
require('my.pack').ensure()

if vim.g.has_gui and vim.g.has_ui then
  vim.cmd.colorscheme('modus')
end
