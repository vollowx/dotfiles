if !exists('g:colors_name') || g:colors_name !=# 'everforest'
    finish
endif
if index(g:everforest_loaded_file_types, 'fern') ==# -1
    call add(g:everforest_loaded_file_types, 'fern')
else
    finish
endif
" syn_begin: fern {{{
" https://github.com/lambdalisue/fern.vim
highlight! link FernMarkedLine Purple
highlight! link FernMarkedText Purple
highlight! link FernRootSymbol FernRootText
highlight! link FernRootText Orange
highlight! link FernLeafSymbol FernLeafText
highlight! link FernLeafText Fg
highlight! link FernBranchSymbol FernBranchText
highlight! link FernBranchText Green
highlight! link FernWindowSelectIndicator TabLineSel
highlight! link FernWindowSelectStatusLine TabLine
" syn_end
" vim: set sw=2 ts=2 sts=2 et tw=80 ft=vim fdm=marker fmr={{{,}}}:
