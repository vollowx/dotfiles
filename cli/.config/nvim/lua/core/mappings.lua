vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

local map = vim.keymap.set
local cmd = vim.api.nvim_create_user_command

-- More consistent behavior when &wrap is set
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

-- Tabpages
---@param tab_action function
---@param default_count number?
---@return function
local function tabswitch(tab_action, default_count)
  return function()
    local count = default_count or vim.v.count
    local num_tabs = vim.fn.tabpagenr('$')
    if num_tabs >= count then
      tab_action(count ~= 0 and count or nil)
      return
    end
    vim.cmd.tablast()
    for _ = 1, count - num_tabs do
      vim.cmd.tabnew()
    end
  end
end
map({ 'n', 'x' }, 'gt', tabswitch(vim.cmd.tabnext))
map({ 'n', 'x' }, 'gT', tabswitch(vim.cmd.tabprev))
map({ 'n', 'x' }, 'gy', tabswitch(vim.cmd.tabprev)) -- gT is too hard to press

map({ 'n', 'x' }, '<Leader>0', '<Cmd>0tabnew<CR>')
map({ 'n', 'x' }, '<Leader>1', tabswitch(vim.cmd.tabnext, 1))
map({ 'n', 'x' }, '<Leader>2', tabswitch(vim.cmd.tabnext, 2))
map({ 'n', 'x' }, '<Leader>3', tabswitch(vim.cmd.tabnext, 3))
map({ 'n', 'x' }, '<Leader>4', tabswitch(vim.cmd.tabnext, 4))
map({ 'n', 'x' }, '<Leader>5', tabswitch(vim.cmd.tabnext, 5))
map({ 'n', 'x' }, '<Leader>6', tabswitch(vim.cmd.tabnext, 6))
map({ 'n', 'x' }, '<Leader>7', tabswitch(vim.cmd.tabnext, 7))
map({ 'n', 'x' }, '<Leader>8', tabswitch(vim.cmd.tabnext, 8))
map({ 'n', 'x' }, '<Leader>9', tabswitch(vim.cmd.tabnext, 9))

-- Correct misspelled word / mark as correct
map('i', '<C-g>+', '<Esc>[szg`]a')
map('i', '<C-g>=', '<C-g>u<Esc>[s1z=`]a<C-G>u')

-- Close all floating windows
map('n', 'q', '<Cmd>fclose<CR>')

-- Edit current file's directory
map({ 'n', 'x' }, '-', '<Cmd>e%:p:h<CR>')

-- Use 'g{' and 'g}' to move to the first/last line of a paragraph
-- stylua: ignore start
map({ 'o' }, 'g{', '<Cmd>silent! normal Vg{<CR>', { noremap = false })
map({ 'o' }, 'g}', '<Cmd>silent! normal Vg}<CR>', { noremap = false })
map({ 'n', 'x' }, 'g{', function() require('utils.misc').goto_paragraph_firstline() end, { noremap = false })
map({ 'n', 'x' }, 'g}', function() require('utils.misc').goto_paragraph_lastline() end, { noremap = false })
-- stylua: ignore end

cmd('Q', 'q', {})
cmd('W', 'w', {})
cmd('Qa', 'qa', {})
cmd('Wq', 'wq', {})
