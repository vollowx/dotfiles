if !exists('g:colors_name') || g:colors_name !=# 'everforest'
    finish
endif
if index(g:everforest_loaded_file_types, 'aerial') ==# -1
    call add(g:everforest_loaded_file_types, 'aerial')
else
    finish
endif
" syn_begin: aerial {{{
" https://github.com/stevearc/aerial.nvim
highlight! link AerialLine CursorLine
highlight! link AerialGuide LineNr
for kind in g:everforest_lsp_kind_color
  execute "highlight! link Aerial" . kind[0] . "Icon " . kind[1]
endfor
" syn_end
" vim: set sw=2 ts=2 sts=2 et tw=80 ft=vim fdm=marker fmr={{{,}}}:
