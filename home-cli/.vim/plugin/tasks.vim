if exists('g:loaded_tasks')
  finish
endif
let g:loaded_tasks = 1

if !exists('g:task_add_cmd')
  let g:task_add_cmd = 'tm add %s'
endif

function! s:GetProjectRoot()
  let l:git_dir = finddir('.git', '.;')
  if empty(l:git_dir)
    return getcwd()
  endif
  return fnamemodify(l:git_dir, ':h')
endfunction

function! s:TaskConvert()
  let l:original_line = getline('.')

  execute "normal gcc"
  let l:uncommented_line = getline('.')

  let l:pattern = '\v(TODO|FIXME|PERF):\s*(.*)'
  let l:match = matchlist(l:uncommented_line, l:pattern)

  if !empty(l:match)
    let l:tag   = l:match[1]
    let l:title = l:match[2]

    let l:cmd = printf(g:task_add_cmd, shellescape(l:title))
    let l:output = system(l:cmd)

    if v:shell_error == 0
      let l:lines = split(l:output, '\n')
      if len(l:lines) >= 2
        let l:id = trim(l:lines[1])

        let l:indent = matchstr(l:uncommented_line, '^\s*')
        let l:new_line = l:indent . 'TASK(' . l:id . '): ' . l:title
        call setline('.', l:new_line)

        execute "normal gcc"
        echo "Task " . l:id . " created. Comment updated."
      else
        call setline('.', l:original_line)
        echoerr "ID not found in command output. Reverting."
      endif
    else
      call setline('.', l:original_line)
      echoerr "Command failed. Reverting."
    endif
  else
    call setline('.', l:original_line)
    echoerr "No TODO/FIXME/PERF tag found. Reverting."
  endif
endfunction

function! s:TaskOpen()
  let l:line = getline('.')

  let l:id_match = matchlist(l:line, '\vTASK\(([^)]+)\)')

  if !empty(l:id_match)
    let l:id = l:id_match[1]
    let l:root = s:GetProjectRoot()
    let l:path = l:root . '/tasks/' . l:id . '/README.md'

    if filereadable(l:path)
      execute 'edit ' . l:path
    else
      echoerr "File not found: " . l:path
    endif
  else
    echoerr "No TASK(ID) found on this line."
  endif
endfunction

command! TaskConvert call s:TaskConvert()
command! TaskOpen call s:TaskOpen()
