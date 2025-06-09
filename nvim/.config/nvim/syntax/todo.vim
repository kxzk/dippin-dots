if exists("b:current_syntax")
  finish
endif

syntax keyword todoTodo   TODO
syntax keyword todoNote   NOTE
syntax keyword todoDone   DONE

syntax match todoCheckboxDone /\v\[[xX]\]/
syntax match todoCheckboxEmpty /\v\[[ ]\]/

syntax region todoDoneLine start=/\[[xX]\]/ end=/$/ contains=todoCheckboxDone keepend

hi def link todoTodo        Statement
hi def link todoNote        WarningMsg
hi def link todoCheckboxDone Comment
hi def link todoCheckboxEmpty Special
hi def link todoDoneLine    Comment
hi def link todoDone        Error

" function to toggle todo checkboxes
function! ToggleTodoCheckbox() range
  for line_num in range(a:firstline, a:lastline)
    let line = getline(line_num)

    " check if line contains an empty checkbox [ ]
    if line =~ '\v\[[ ]\]'
      " replace [ ] with [x]
      let new_line = substitute(line, '\v\[[ ]\]', '[x]', 'g')
      call setline(line_num, new_line)
    " check if line contains a checked checkbox [x] or [x]
    elseif line =~ '\v\[[xX]\]'
      " replace [x] or [x] with [ ]
      let new_line = substitute(line, '\v\[[xX]\]', '[ ]', 'g')
      call setline(line_num, new_line)
    endif
  endfor
endfunction

" create custom comment function that also toggles checkboxes
function! CommentAndToggleTodo() range
  " first toggle any checkboxes
  execute a:firstline . ',' . a:lastline . 'call ToggleTodoCheckbox()'

  " then apply normal commenting (adjust this based on your comment plugin)
  " for built-in commenting:
  execute "normal! " . a:firstline . "G"
  if a:firstline != ba:lastline
    execute "normal! V" . (a:lastline - a:firstline) . "jgc"
  else
    execute "normal! gcc"
  endif
endfunction

" map gcc to our custom function in normal mode
nnoremap <buffer> gcc :call CommentAndToggleTodo()<CR>

" map gc to our custom function in visual mode
vnoremap <buffer> gc :call CommentAndToggleTodo()<CR>

let b:current_syntax = "todo"
