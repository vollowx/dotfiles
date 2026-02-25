if !exists('g:colors_name') || g:colors_name !=# 'everforest'
    finish
endif
if index(g:everforest_loaded_file_types, 'neo-tree') ==# -1
    call add(g:everforest_loaded_file_types, 'neo-tree')
else
    finish
endif
let s:configuration = everforest#get_configuration()
let s:palette = everforest#get_palette(s:configuration.background, s:configuration.colors_override)
" syn_begin: neo-tree {{{
" https://github.com/nvim-neo-tree/neo-tree.nvim
if !s:configuration.transparent_background
  call everforest#highlight('NeoTreeNormal', s:palette.fg, s:palette.bg_dim)
  call everforest#highlight('NeoTreeEndOfBuffer', s:palette.bg_dim, s:palette.bg_dim)
  call everforest#highlight('NeoTreeVertSplit', s:palette.bg0, s:palette.bg0)
endif
highlight! link NeoTreeDirectoryIcon Orange
highlight! link NeoTreeGitAdded Green
highlight! link NeoTreeGitConflict Yellow
highlight! link NeoTreeGitDeleted Red
highlight! link NeoTreeGitIgnored Grey
highlight! link NeoTreeGitModified Blue
highlight! link NeoTreeGitUnstaged Purple
highlight! link NeoTreeGitUntracked Fg
highlight! link NeoTreeGitStaged Purple
highlight! link NeoTreeDimText Grey
highlight! link NeoTreeIndentMarker NonText
highlight! link NeoTreeNormalNC NeoTreeNormal
highlight! link NeoTreeSignColumn NeoTreeNormal
highlight! link NeoTreeRootName Title
if &background ==# 'light'
  call everforest#highlight('NeoTreeCursorLine', s:palette.none, s:palette.bg0)
endif
" syn_end
" vim: set sw=2 ts=2 sts=2 et tw=80 ft=vim fdm=marker fmr={{{,}}}:
