local o = vim.opt
local go = vim.go
local g = vim.g

-- stylua: ignore start
o.cursorlineopt  = 'both'
o.cursorline     = true
o.foldcolumn     = 'auto'
o.foldlevelstart = 99
o.foldtext       = ''
o.helpheight     = 10
o.showmode       = false
o.mousemoveevent = true
o.number         = true
o.ruler          = true
o.pumheight      = 16
o.scrolloff      = 4
o.sidescrolloff  = 8
o.signcolumn     = 'yes:1'
o.laststatus     = 3
o.cmdheight      = 0
o.splitright     = true
o.splitbelow     = true
o.swapfile       = false
o.undofile       = true
o.updatetime     = 100
o.wrap           = false
o.linebreak      = true
o.breakindent    = true
o.smoothscroll   = true
o.ignorecase     = true
o.smartcase      = true
o.conceallevel   = 2
o.softtabstop    = 2
o.shiftwidth     = 2
o.expandtab      = true
o.autoindent     = true
o.autowriteall   = true
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

go.statusline = [[%!v:lua.require'core._internal.statusline'.get()]]
go.tabline = [[%!v:lua.require'core._internal.tabline'.get()]]
