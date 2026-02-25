if !exists('g:colors_name') || g:colors_name !=# 'everforest'
    finish
endif
if index(g:everforest_loaded_file_types, 'octo') ==# -1
    call add(g:everforest_loaded_file_types, 'octo')
else
    finish
endif
let s:configuration = everforest#get_configuration()
let s:palette = everforest#get_palette(s:configuration.background, s:configuration.colors_override)
" syn_begin: octo {{{
" https://github.com/pwntester/octo.nvim
call everforest#highlight('OctoViewer', s:palette.bg0, s:palette.blue)
call everforest#highlight('OctoGreenFloat', s:palette.green, s:palette.bg2)
call everforest#highlight('OctoRedFloat', s:palette.red, s:palette.bg2)
call everforest#highlight('OctoPurpleFloat', s:palette.purple, s:palette.bg2)
call everforest#highlight('OctoYellowFloat', s:palette.yellow, s:palette.bg2)
call everforest#highlight('OctoBlueFloat', s:palette.blue, s:palette.bg2)
call everforest#highlight('OctoGreyFloat', s:palette.grey1, s:palette.bg2)
call everforest#highlight('OctoBubbleGreen', s:palette.bg0, s:palette.green)
call everforest#highlight('OctoBubbleRed', s:palette.bg0, s:palette.red)
call everforest#highlight('OctoBubblePurple', s:palette.bg0, s:palette.purple)
call everforest#highlight('OctoBubbleYellow', s:palette.bg0, s:palette.yellow)
call everforest#highlight('OctoBubbleBlue', s:palette.bg0, s:palette.blue)
call everforest#highlight('OctoBubbleGrey', s:palette.bg0, s:palette.grey1)
highlight! link OctoGreen Green
highlight! link OctoRed Red
highlight! link OctoPurple Purple
highlight! link OctoYellow Yellow
highlight! link OctoBlue Blue
highlight! link OctoGrey Grey
highlight! link OctoBubbleDelimiterGreen Green
highlight! link OctoBubbleDelimiterRed Red
highlight! link OctoBubbleDelimiterPurple Purple
highlight! link OctoBubbleDelimiterYellow Yellow
highlight! link OctoBubbleDelimiterBlue Blue
highlight! link OctoBubbleDelimiterGrey Grey
" syn_end
" vim: set sw=2 ts=2 sts=2 et tw=80 ft=vim fdm=marker fmr={{{,}}}:
