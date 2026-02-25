if !exists('g:colors_name') || g:colors_name !=# 'everforest'
    finish
endif
if index(g:everforest_loaded_file_types, 'NeogitStatus') ==# -1
    call add(g:everforest_loaded_file_types, 'NeogitStatus')
else
    finish
endif
" syn_begin: NeogitStatus/NeogitCommitView {{{
" https://github.com/TimUntersberger/neogit
highlight! link NeogitNotificationInfo Blue
highlight! link NeogitNotificationWarning Yellow
highlight! link NeogitNotificationError Red
highlight! link NeogitDiffAdd Green
highlight! link NeogitDiffDelete Red
highlight! link NeogitDiffContextHighlight CursorLine
highlight! link NeogitHunkHeaderHighlight TabLine
highlight! link NeogitHunkHeader TabLineFill
highlight! link NeogitCommandCodeNormal Green
highlight! link NeogitCommandCodeError Red
highlight! link NeogitCommitViewHeader diffIndexLine
highlight! link NeogitFilePath diffFile
" syn_end
" vim: set sw=2 ts=2 sts=2 et tw=80 ft=vim fdm=marker fmr={{{,}}}:
