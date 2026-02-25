if !exists('g:colors_name') || g:colors_name !=# 'everforest'
    finish
endif
if index(g:everforest_loaded_file_types, 'mason') ==# -1
    call add(g:everforest_loaded_file_types, 'mason')
else
    finish
endif
let s:configuration = everforest#get_configuration()
let s:palette = everforest#get_palette(s:configuration.background, s:configuration.colors_override)
" syn_begin: mason {{{
" https://github.com/williamboman/mason.nvim
call everforest#highlight('MasonHeader', s:palette.bg0, s:palette.green, 'bold')
call everforest#highlight('MasonHeaderSecondary', s:palette.bg0, s:palette.orange, 'bold')
highlight! link MasonHighlight Green
highlight! link MasonHighlightSecondary Yellow
call everforest#highlight('MasonHighlightBlock', s:palette.bg0, s:palette.aqua)
call everforest#highlight('MasonHighlightBlockBold', s:palette.bg0, s:palette.aqua, 'bold')
call everforest#highlight('MasonHighlightBlockSecondary', s:palette.bg0, s:palette.yellow)
call everforest#highlight('MasonHighlightBlockBoldSecondary', s:palette.bg0, s:palette.yellow, 'bold')
call everforest#highlight('MasonMuted', s:palette.grey0, s:palette.none)
call everforest#highlight('MasonMutedBlock', s:palette.bg0, s:palette.grey0)
" syn_end
" vim: set sw=2 ts=2 sts=2 et tw=80 ft=vim fdm=marker fmr={{{,}}}:
