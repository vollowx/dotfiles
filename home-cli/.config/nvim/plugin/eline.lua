-- Statusline that looks like the vanilla Emacs modeline
vim.g.qf_disable_statusline = 1
vim.opt.statusline = "%!v:lua.require'my.plugins.eline'()"
