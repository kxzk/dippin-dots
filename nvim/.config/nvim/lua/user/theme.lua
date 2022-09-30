require('nord').set()

local cmd = vim.cmd

cmd [[highlight Comment guifg=#4C566A]]         -- comment color
cmd [[highlight LineNr guifg=#3B4252]]          -- dim line numbers
cmd [[highlight CursorLineNr guifg=#EBCB8B]]    -- brighter cursorline number
cmd [[highlight EndOfBuffer guifg=#2E3440]]     -- dim tilde under line number
cmd [[highlight VertSplit guifg=#EBCB8B gui=None guibg=None]]   -- remove bad split coloring
cmd [[highlight MsgArea guifg=#3B4252]]         -- dim command line/message area
