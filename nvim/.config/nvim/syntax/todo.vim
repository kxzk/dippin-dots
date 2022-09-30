if exists("b:current_syntax")
    finish
endif

syn match opentask "- \[ \]"
hi opentask guifg=#81a1c1

syn match arrow "->"
hi arrow guifg=#b48ead

syn match dcol "::"
hi dcol guifg=#81a1c1

syn match endtask "- \[x\].*$"
hi endtask guifg=#3b4252

syn match header "\[\[.*\]\]"
hi header guifg=#ebcb8b

syn match subheader "--.*--"
hi subheader guifg=#81a1c1

let b:current_syntax = "todo"
