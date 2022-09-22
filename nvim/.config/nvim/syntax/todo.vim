if exists("b:current_syntax")
    finish
endif

syn match opentask "- \[ \]"
hi opentask ctermfg=2

syn match subtask "->"
hi subtask ctermfg=6

syn match endtask "- \[x\].*$"
hi endtask ctermfg=8

syn match header "\[\[.*\]\]"
hi header ctermfg=3

syn match subheader "--.*--"
hi subheader ctermfg=4

let b:current_syntax = "todo"
