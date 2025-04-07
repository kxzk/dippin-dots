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

let b:current_syntax = "todo"
