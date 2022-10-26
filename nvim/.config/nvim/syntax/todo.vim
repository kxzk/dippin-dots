if exists("b:current_syntax")
    finish
endif

syn match opentask "- \[ \]"
hi opentask guifg=#81a1c1

syn match important "!!"
hi important guifg=#BF616A

syn match kinda_important "++"
hi kinda_important guifg=#D08770

syn match maybe_important "__"
hi maybe_important guifg=#8FBCBB

syn match list "*"
hi list guifg=#A3BE8C

syn match arrow "->"
hi arrow guifg=#b48ead

syn match dcol "::"
hi dcol guifg=#81a1c1

syn match endtask "- \[x\].*$"
hi endtask guifg=#434C5E

syn match header "\[\[.*\]\]"
hi header guifg=#ebcb8b

syn match subheader "--.*--"
hi subheader guifg=#81a1c1

let b:current_syntax = "todo"
