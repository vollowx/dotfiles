vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

local map = vim.keymap.set
local cmd = vim.api.nvim_create_user_command

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

-- Use 'g{' and 'g}' to move to the first/last line of a paragraph
-- stylua: ignore start
map({ 'o' }, 'g{', '<Cmd>silent! normal Vg{<CR>', { noremap = false })
map({ 'o' }, 'g}', '<Cmd>silent! normal Vg}<CR>', { noremap = false })
map({ 'n', 'x' }, 'g{', function() require('utils.misc').goto_paragraph_firstline() end, { noremap = false })
map({ 'n', 'x' }, 'g}', function() require('utils.misc').goto_paragraph_lastline() end, { noremap = false })
-- stylua: ignore end

cmd('CopyGitLink', function()
  require('core._internal.git-link').copy_url()
  vim.api.nvim_feedkeys(
    vim.api.nvim_replace_termcodes('<Esc>', true, false, true),
    'n',
    false
  )
end, { range = true })
map(
  { 'n', 'x' },
  '<Leader>gy',
  '<Cmd>CopyGitLink<CR>',
  { desc = 'Copy line[s] link' }
)

-- Sometimes we cannot release Shift so quickly
cmd('Q', 'q', {})
cmd('W', 'w', {})
cmd('Qa', 'qa', {})
cmd('Wq', 'wq', {})
