let g:ExecuteSupportedLang = {
      \'cpp': 's:CppExecutor',
      \'python': 's:PyExecutor',
      \'javascript': 's:NodeExecutor'
      \}

function! SupportedLang()
  if has_key(g:ExecuteSupportedLang, &ft)
    let g:compile_mode = 1
    let ExecutorRef = function(g:ExecuteSupportedLang[&ft])
    let command = ExecutorRef()
    return command
  endif
  return -1
endfunction

function! s:CppExecutor() abort
  let inputfile = expand('%:p')
  let outputfile = expand('%:p:r')
  let command = "g++ ".inputfile." -o ".outputfile." && ".outputfile
  return command
endfunction

function! s:PyExecutor() abort
  let inputfile = expand('%:p')
  let command = "python ".inputfile
  return command
endfunction

function! s:NodeExecutor() abort
  let inputfile = expand('%:p')
  let command = "node ".inputfile
  return command
endfunction

function! Execute() abort
  let command = SupportedLang()
  if command == -1
    echo &ft." is not supported!"
    return
  endif
  if has('nvim')
    exec "15Term ".command
  else
    exec "term ".command
  endif
endfunction

command! -nargs=0 Execute call Execute()
