if exists('g:loaded_compile')
  finish
endif
let g:loaded_compile = 1

let g:original_makeprg = &g:makeprg
let g:last_input = 'make -k'

function! s:run_compile(is_loclist)
  let l:input = input('Compile command: ', g:last_input)

  if empty(l:input)
    echo "Compilation cancelled."
    return
  endif

  let g:last_input = l:input
  let &g:makeprg = l:input

  try
    if a:is_loclist
      execute 'lmake!'
      lopen
    else
      execute 'make!'
      copen
    endif
  finally
    " This ensures makeprg is always restored, even if lmake/make errors out
    let &g:makeprg = g:original_makeprg
  endtry
endfunction

command! Compile  call s:run_compile(0)
command! LCompile call s:run_compile(1)
