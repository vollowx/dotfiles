-- More consistent behavior when &wrap is set
-- stylua: ignore start
vim.keymap.set({ 'n', 'x' }, 'j', 'v:count ? "j" : "gj"', { expr = true })
vim.keymap.set({ 'n', 'x' }, 'k', 'v:count ? "k" : "gk"', { expr = true })
vim.keymap.set({ 'n', 'x' }, '<Down>', 'v:count ? "<Down>" : "g<Down>"', { expr = true, replace_keycodes = false })
vim.keymap.set({ 'n', 'x' }, '<Up>',   'v:count ? "<Up>"   : "g<Up>"',   { expr = true, replace_keycodes = false })
vim.keymap.set({ 'i' }, '<Down>', '<Cmd>norm! g<Down><CR>')
vim.keymap.set({ 'i' }, '<Up>',   '<Cmd>norm! g<Up><CR>')
-- stylua: ignore end

-- Multi-window operations
-- stylua: ignore start
vim.keymap.set({ 'n', 'x' }, '<M-h>', '<C-w>h')
vim.keymap.set({ 'n', 'x' }, '<M-j>', '<C-w>j')
vim.keymap.set({ 'n', 'x' }, '<M-k>', '<C-w>k')
vim.keymap.set({ 'n', 'x' }, '<M-l>', '<C-w>l')
vim.keymap.set({ 'n', 'x' }, '<M-n>', '<C-w>n')
vim.keymap.set({ 'n', 'x' }, '<M-q>', '<C-w>q')
vim.keymap.set({ 'n', 'x' }, '<M-s>', '<C-w>s')
vim.keymap.set({ 'n', 'x' }, '<M-v>', '<C-w>v')
vim.keymap.set({ 'n', 'x' }, '<M-x>', '<C-w>x')

vim.keymap.set('t', '<C-^>', '<Cmd>b#<CR>',       { replace_keycodes = false })
vim.keymap.set('t', '<C-6>', '<Cmd>b#<CR>',       { replace_keycodes = false })
vim.keymap.set('t', '<Esc>', '<Cmd>stopi<CR>',    { replace_keycodes = false })
vim.keymap.set('t', '<M-h>', '<Cmd>wincmd h<CR>', { replace_keycodes = false })
vim.keymap.set('t', '<M-j>', '<Cmd>wincmd j<CR>', { replace_keycodes = false })
vim.keymap.set('t', '<M-k>', '<Cmd>wincmd k<CR>', { replace_keycodes = false })
vim.keymap.set('t', '<M-l>', '<Cmd>wincmd l<CR>', { replace_keycodes = false })
-- stylua: ignore end

-- Buffer navigation
vim.keymap.set('n', ']b', '<Cmd>exec v:count1 . "bn"<CR>')
vim.keymap.set('n', '[b', '<Cmd>exec v:count1 . "bp"<CR>')

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
vim.keymap.set({ 'n', 'x' }, 'gt', tabswitch(vim.cmd.tabnext))
vim.keymap.set({ 'n', 'x' }, 'gT', tabswitch(vim.cmd.tabprev))
vim.keymap.set({ 'n', 'x' }, 'gy', tabswitch(vim.cmd.tabprev)) -- gT is too hard to press

vim.keymap.set({ 'n', 'x' }, '<Leader>0', '<Cmd>0tabnew<CR>')
vim.keymap.set({ 'n', 'x' }, '<Leader>1', tabswitch(vim.cmd.tabnext, 1))
vim.keymap.set({ 'n', 'x' }, '<Leader>2', tabswitch(vim.cmd.tabnext, 2))
vim.keymap.set({ 'n', 'x' }, '<Leader>3', tabswitch(vim.cmd.tabnext, 3))
vim.keymap.set({ 'n', 'x' }, '<Leader>4', tabswitch(vim.cmd.tabnext, 4))
vim.keymap.set({ 'n', 'x' }, '<Leader>5', tabswitch(vim.cmd.tabnext, 5))
vim.keymap.set({ 'n', 'x' }, '<Leader>6', tabswitch(vim.cmd.tabnext, 6))
vim.keymap.set({ 'n', 'x' }, '<Leader>7', tabswitch(vim.cmd.tabnext, 7))
vim.keymap.set({ 'n', 'x' }, '<Leader>8', tabswitch(vim.cmd.tabnext, 8))
vim.keymap.set({ 'n', 'x' }, '<Leader>9', tabswitch(vim.cmd.tabnext, 9))

-- Correct misspelled word / mark as correct
vim.keymap.set('i', '<C-g>+', '<Esc>[szg`]a')
vim.keymap.set('i', '<C-g>=', '<C-g>u<Esc>[s1z=`]a<C-G>u')

-- Close all floating windows
vim.keymap.set('n', 'q', '<Cmd>fclose<CR>')

-- Edit current file's directory
vim.keymap.set({ 'n', 'x' }, '-', '<Cmd>e%:p:h<CR>')

-- Use 'g{' and 'g}' to move to the first/last line of a paragraph
-- stylua: ignore start
vim.keymap.set({ 'o' }, 'g{', '<Cmd>silent! normal Vg{<CR>', { noremap = false })
vim.keymap.set({ 'o' }, 'g}', '<Cmd>silent! normal Vg}<CR>', { noremap = false })
vim.keymap.set({ 'n', 'x' }, 'g{', function() require('utils.misc').goto_paragraph_firstline() end, { noremap = false })
vim.keymap.set({ 'n', 'x' }, 'g}', function() require('utils.misc').goto_paragraph_lastline() end, { noremap = false })
-- stylua: ignore end
