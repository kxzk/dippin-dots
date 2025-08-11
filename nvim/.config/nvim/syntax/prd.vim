" Vim syntax file for PRD files
" Language: prd
" Filetype: .prd

if exists("b:current_syntax")
  finish
endif

" Headers
syn match prdH1 "^#\s.*$"
syn match prdH2 "^##\s.*$"
syn match prdH3 "^###\s.*$"

" Section labels (bold text with colon)
syn match prdLabel "\*\*[^:]*:\*\*"

" List items and markers
syn match prdListMarker "^\s*-"

" File references (@ mentions)
syn match prdFileRef "@\S\+"

" Plain text content
syn match prdText "^\s*[^-#*@].*$"

" Define highlighting
hi def link prdH1 Title
hi def link prdH2 Statement
hi def link prdH3 Keyword
hi def link prdLabel Type
hi def link prdListMarker Special
hi def link prdFileRef Identifier
hi def link prdText Normal

let b:current_syntax = "prd"
