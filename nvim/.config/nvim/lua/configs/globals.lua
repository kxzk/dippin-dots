local g = vim.g

-- make it stop yelling
vim.deprecate = function() end

vim.o.background = "dark"
vim.cmd("colorscheme monokai-pro-octagon")
g.do_filetype_lua = 1

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

g.netrw_liststyle = 3
g.netrw_banner = 0
g.netrw_browse_split = 0
g.netrw_winsize = 20
g.netrw_altv = 1
g.netrw_hide = 0
g.netrw_cursor = 0

-- copilot
-- g.copilot_filtypes = { '*': v:false, 'python': v:true }
g.copilot_node_command = "/opt/homebrew/bin/node"
