if !exists('g:colors_name') || g:colors_name !=# 'everforest'
    finish
endif
if index(g:everforest_loaded_file_types, 'neotest-summary') ==# -1
    call add(g:everforest_loaded_file_types, 'neotest-summary')
else
    finish
endif
let s:configuration = everforest#get_configuration()
let s:palette = everforest#get_palette(s:configuration.background, s:configuration.colors_override)
" syn_begin: neotest-summary {{{
" https://github.com/nvim-neotest/neotest
if has('nvim')
highlight! link NeotestNamespace Purple
highlight! link NeotestFile Aqua
highlight! link NeotestDir Directory
highlight! link NeotestIndent NonText
call everforest#highlight('NeotestExpandMarker', s:palette.bg5, s:palette.none)
highlight! link NeotestAdapterName Title
highlight! link NeotestMarked Orange
highlight! link NeotestTarget Red
endif
" syn_end
" vim: set sw=2 ts=2 sts=2 et tw=80 ft=vim fdm=marker fmr={{{,}}}:
