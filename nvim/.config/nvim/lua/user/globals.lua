local g = vim.g

g.mapleader = ' '           -- space leader
g.background = 'dark'
g.do_filetype_lua = 1

if (vim.loop.os_uname().sysname == 'Darwin') then
    g.python3_host_prog = '/opt/homebrew/bin/python3'
else
    g.python3_host_prog = '/usr/bin/python3'
end

g.black_fast = 1
g.NERDSpaceDelims = 1
g.NERDTrimTrailingWhitespace = 1

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
g.netrw_browse_split = 1
g.netrw_winsize = 20
g.netrw_altv = 1
g.netrw_hide = 0
g.netrw_cursor = 0
