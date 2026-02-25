if !exists('g:colors_name') || g:colors_name !=# 'everforest'
    finish
endif
if index(g:everforest_loaded_file_types, 'html') ==# -1
    call add(g:everforest_loaded_file_types, 'html')
else
    finish
endif
let s:configuration = everforest#get_configuration()
let s:palette = everforest#get_palette(s:configuration.background, s:configuration.colors_override)
" syn_begin: html/markdown/javascriptreact/typescriptreact {{{
" builtin: https://notabug.org/jorgesumle/vim-html-syntax {{{
call everforest#highlight('htmlH1', s:palette.red, s:palette.none, 'bold')
call everforest#highlight('htmlH2', s:palette.orange, s:palette.none, 'bold')
call everforest#highlight('htmlH3', s:palette.yellow, s:palette.none, 'bold')
call everforest#highlight('htmlH4', s:palette.green, s:palette.none, 'bold')
call everforest#highlight('htmlH5', s:palette.blue, s:palette.none, 'bold')
call everforest#highlight('htmlH6', s:palette.purple, s:palette.none, 'bold')
call everforest#highlight('htmlLink', s:palette.none, s:palette.none, 'underline')
call everforest#highlight('htmlBold', s:palette.none, s:palette.none, 'bold')
call everforest#highlight('htmlBoldUnderline', s:palette.none, s:palette.none, 'bold,underline')
call everforest#highlight('htmlBoldItalic', s:palette.none, s:palette.none, 'bold,italic')
call everforest#highlight('htmlBoldUnderlineItalic', s:palette.none, s:palette.none, 'bold,underline,italic')
call everforest#highlight('htmlUnderline', s:palette.none, s:palette.none, 'underline')
call everforest#highlight('htmlUnderlineItalic', s:palette.none, s:palette.none, 'underline,italic')
call everforest#highlight('htmlItalic', s:palette.none, s:palette.none, 'italic')
highlight! link htmlTag Green
highlight! link htmlEndTag Blue
highlight! link htmlTagN OrangeItalic
highlight! link htmlTagName OrangeItalic
highlight! link htmlArg Aqua
highlight! link htmlScriptTag Purple
highlight! link htmlSpecialTagName RedItalic
" }}}
" nvim-treesitter/nvim-treesitter {{{
highlight! link htmlTSText TSNone
if has('nvim-0.8')
  highlight! link @text.html htmlTSText
endif
" }}}
" syn_end
" vim: set sw=2 ts=2 sts=2 et tw=80 ft=vim fdm=marker fmr={{{,}}}:
