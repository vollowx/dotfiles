if !exists('g:last_compile_command')
  let g:last_compile_command = 'make -k'
endif

function! s:run_compile(is_loclist)
  let l:cmd = input('Compile command: ', g:last_compile_command)

  if empty(l:cmd)
    echo "\nCompilation cancelled."
    return
  endif

  let g:last_compile_command = l:cmd
  let l:old_makeprg = &l:makeprg
  let &l:makeprg = l:cmd

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
    let &l:makeprg = l:old_makeprg
  endtry
endfunction

command! Compile  call s:run_compile(0)
command! LCompile call s:run_compile(1)
