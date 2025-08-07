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
map({ 'n', 'x' }, '<M-h>', '<C-w>h')
map({ 'n', 'x' }, '<M-j>', '<C-w>j')
map({ 'n', 'x' }, '<M-k>', '<C-w>k')
map({ 'n', 'x' }, '<M-l>', '<C-w>l')
map({ 'n', 'x' }, '<M-n>', '<C-w>n')
map({ 'n', 'x' }, '<M-q>', '<C-w>q')
map({ 'n', 'x' }, '<M-s>', '<C-w>s')
map({ 'n', 'x' }, '<M-v>', '<C-w>v')
map({ 'n', 'x' }, '<M-x>', '<C-w>x')

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

-- Sometimes we cannot release Shift so quickly
cmd('Q', 'q', {})
cmd('W', 'w', {})
cmd('Qa', 'qa', {})
cmd('Wq', 'wq', {})
