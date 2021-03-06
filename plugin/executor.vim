if exists('g:executor_loaded')
    finish
endif

let g:executor_loaded = 1


let g:ExecutorSupportedLang = {
      \'cpp': 's:CppExecutor',
      \'python': 's:PyExecutor',
      \'javascript': 's:NodeExecutor',
      \'go': 's:GoExecutor'
      \}

function! GetCommand()
  if has_key(g:ExecutorSupportedLang, &ft)
    let g:compile_mode = 1
    let ExecutorRef = function(g:ExecutorSupportedLang[&ft])
    let command = ExecutorRef()
    return command
  endif
  return -1
endfunction

function! s:CppExecutor() abort
  let inputfile = expand('%:t')
  let outputfile = expand('%:t:r')
  let command = "g++ ".inputfile." -o ".outputfile." && ./".outputfile
  return command
endfunction

function! s:PyExecutor() abort
  let inputfile = expand('%:t')
  let command = "python ".inputfile
  return command
endfunction

function! s:NodeExecutor() abort
  let inputfile = expand('%:t')
  let command = "node ".inputfile
  return command
endfunction

function! s:GoExecutor() abort
  let inputfile = expand('%:t')
  let command = "go run ".inputfile
  return command
endfunction

function! Execute() abort
  let command = GetCommand()
  if command == -1
    echo &ft." is not supported!"
    return
  endif
  let path = expand('%:p:h')
  let command = "cd ".path." && ".command
  if has('nvim')
    if exists('g:executor_bufnr') && buffer_exists(g:executor_bufnr)
      exec "bd! ".g:executor_bufnr
    endif
    exec "15Term ".command
    let g:executor_bufnr = bufnr()
    let g:executor_winnr = winnr()
    let g:executor_winid = win_getid()
    stopinsert
  else
    exec "term ".command
  endif
endfunction

command! -nargs=0 Execute call Execute()
