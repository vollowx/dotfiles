if !exists('g:colors_name') || g:colors_name !=# 'everforest'
    finish
endif
if index(g:everforest_loaded_file_types, 'toml') ==# -1
    call add(g:everforest_loaded_file_types, 'toml')
else
    finish
endif
let s:configuration = everforest#get_configuration()
let s:palette = everforest#get_palette(s:configuration.background, s:configuration.colors_override)
" syn_begin: toml {{{
" builtin: https://github.com/cespare/vim-toml {{{
call everforest#highlight('tomlTable', s:palette.orange, s:palette.none, 'bold')
highlight! link tomlKey Green
highlight! link tomlString Fg
highlight! link tomlDate Special
highlight! link tomlBoolean Aqua
highlight! link tomlTableArray tomlTable
" }}}
" nvim-treesitter/nvim-treesitter {{{
highlight! link tomlTSProperty tomlKey
highlight! link tomlTSString tomlString
if has('nvim-0.8')
  highlight! link @property.toml tomlTSProperty
  highlight! link @string.toml tomlTSString
endif
" }}}
" syn_end
" vim: set sw=2 ts=2 sts=2 et tw=80 ft=vim fdm=marker fmr={{{,}}}:
