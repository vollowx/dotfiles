if !exists('g:colors_name') || g:colors_name !=# 'everforest'
    finish
endif
if index(g:everforest_loaded_file_types, 'json') ==# -1
    call add(g:everforest_loaded_file_types, 'json')
else
    finish
endif
" syn_begin: json {{{
" builtin {{{
highlight! link jsonKeyword Green
highlight! link jsonString Fg
highlight! link jsonQuote Grey
" }}}
" nvim-treesitter/nvim-treesitter {{{
highlight! link jsonTSLabel jsonKeyword
highlight! link jsonTSString jsonString
highlight! link jsonTSStringEscape SpecialChar
if has('nvim-0.8')
  highlight! link @label.json jsonTSLabel
  highlight! link @string.json jsonTSString
  highlight! link @string.escape.json jsonTSStringEscape
endif
" }}}
" syn_end
" vim: set sw=2 ts=2 sts=2 et tw=80 ft=vim fdm=marker fmr={{{,}}}:
