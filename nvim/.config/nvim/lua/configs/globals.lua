local g = vim.g

g.background = "dark"
g.do_filetype_lua = 1

-- my variations to the new neovim default colorscheme
vim.cmd([[highlight Comment guifg=#3d4671]]) -- comment color
vim.cmd([[highlight LineNr guifg=#3d4671]]) -- dim line numbers
vim.cmd([[highlight EndOfBuffer guifg=#14161b]]) -- dim tilde under line number
vim.cmd([[highlight CursorLine guibg=#1c1d23]])
vim.cmd([[highlight CursorLineNr guifg=#2c2e33]]) -- brighter cursorline number
vim.cmd([[highlight MsgArea guifg=#2c2e33]]) -- dim command line/message area
-- vim.cmd([[highlight VertSplit guifg=#EBCB8B gui=None guibg=None]]) -- remove bad split coloring

if vim.loop.os_uname().sysname == "Darwin" then
	g.python3_host_prog = "/opt/homebrew/bin/python3"
else
	g.python3_host_prog = "/usr/bin/python3"
end

-- g.python_recommended_style = 0

-- netrw cheatsheet --
-- - -> up directory
-- a -> dots yes/no
-- d -> make dir
-- D -> remove file
-- p -> preview
-- r -> reverse sort
-- R -> rename
-- s -> sort
-- % -> new file

g.netrw_liststlye = 3
g.netrw_banner = 0
g.netrw_browse_split = 0
g.netrw_winsize = 20
g.netrw_altv = 1
g.netrw_hide = 0
g.netrw_cursor = 0

-- copilot
-- g.copilot_filtypes = { '*': v:false, 'python': v:true }
g.copilot_node_command = "/opt/homebrew/bin/node"
