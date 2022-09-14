--[[

neovim init.lua
by @kadekillary

--]]

-- << SHORTCUTS >> --

local g = vim.g             -- globals
local opt = vim.opt         -- set options
local cmd = vim.cmd         -- commands
local o = vim.o             -- editor options (like :set)
local fn = vim.fn           -- invokes vim-function
local api = vim.api         -- invokes nvim api
local autocmd = vim.api.nvim_create_autocmd
local autogroup = vim.api.nvim_create_augroup

-- << OPTIONS >> --

g.mapleader = ' '           -- space leader
g.background = 'dark'

cmd [[colorscheme default]]
cmd [[filetype plugin indent on]]

-- [[ UI ]] --

opt.shortmess:append 'sI'   -- turn off neovim into message
opt.number = true
opt.relativenumber = true
opt.showmatch = true        -- highlight matching parens
opt.ignorecase = true       -- ignore case when searching
opt.conceallevel = 0        -- make `` visible in markdown files
opt.showmode = false        -- remove annoying -- INSERT -- commands at bottom
opt.showcmd = false         -- do not show partial command in last line
opt.splitbelow = true
opt.splitright = true

-- [[ CORE ]] --

opt.syntax = 'on'           -- syntax highlighting on, duh
opt.laststatus = 3          -- global statusline
opt.completeopt = 'menuone,noinsert,noselect'   -- autocomplete options
-- opt.clipboard = 'unnamedplus'   -- copy to system clipboard
opt.mouse = 'a'             -- turn on mouse support
opt.scrolloff = 3           -- min lines to keep above/below cursor
opt.foldmethod = 'manual'   -- manual folding -> zf{motion}, zo -> open, zc -> close

-- [[ INDENT ]] --

opt.expandtab = true        -- spaces instead of tabs
opt.shiftwidth = 4          -- shift 4 spaces when tab
opt.tabstop = 4             -- 1 tab == 4 spaces
opt.smartindent = true
opt.shiftround = true        -- round indent to multiple of shiftwidth

-- [[ PERF ]] --

opt.hidden = true           -- enable background buffers
opt.history = 50            -- remember n commands :example
opt.lazyredraw = true       -- faster scrolling
opt.backup = false          -- no backups
opt.writebackup = false     -- no backups while editing (living on the edge)
opt.swapfile = false        -- no swapfile
opt.updatecount = 0         -- no swapfiles after some number of updates
opt.updatetime = 50         -- less lag

-- << TEMPLATES >> --

cmd [[
    augroup Templates
        autocmd!
        autocmd BufNewFile *.py 0r ~/.config/nvim/templates/py.skeleton
        autocmd BufNewFile *.go 0r ~/.config/nvim/templates/go.skeleton
    augroup END
]]

-- << PYTHON >> --

-- @TODO: replace this with lua way
cmd [[
   augroup PyOpts
       autocmd!
       autocmd Filetype python nmap <leader>r :split term://python3 %<CR>
   augroup END
]]

-- << TERMINAL >> --

-- @TODO: do it the lua way, cheating
cmd [[
    augroup TermOpts
        autocmd!
        autocmd TermOpen * setlocal nonumber norelativenumber
    augroup END
]]

-- << KEYMAPS >> --

-- helper for simple mappings
local function map(mode, lhs, rhs, opts)
    local options = { noremap = true, silent = true }
    if opts then
        options = vim.tbl_extend('force', options, opts)
    end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- quick init.lua editing/sourcing
map('n', '<leader>-', ':e $HOME/.config/nvim/init.lua<CR>')
map('n', '<F1>', ':source $HOME/.config/nvim/init.lua<CR>')

-- fast saves/quit
map('n', '<leader>w', ':w!<CR>')
map('n', '<leader>q', ':q!<CR>')

-- breaks my brain othwerwise
map('n', 'Y', 'yy')

-- fast searching
map('n', '<leader>s', ':%s/')

-- clear search highlighting
map('n', '<BS>', ':nohl<CR>')

-- get out of term
-- map('i', '<ESC>', '<C-\><C-N>', { noremap = true })

-- netrw -> nerdtree-esque
map('n', '<leader>0', ':Vexplore<CR>')

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

-- << STATUSLINE >> --

-- @TODO: comment these
local function branch_name()
	local branch = io.popen('git rev-parse --abbrev-ref HEAD 2> /dev/null')
	if branch then
		local name = branch:read('*l')
		branch:close()
		if name then
			return name .. ' | '
		else
			return ''
		end
	end
end

local function file_name()
	local root_path = vim.fn.getcwd()
	local root_dir = root_path:match('[^/]+$')
	local home_path = vim.fn.expand('%:~'):gsub('/Desktop', '/D')
    return home_path
end

local function hl(group, fg, bg)
    cmd('highlight ' .. group .. ' ctermfg=' .. fg .. ' ctermbg=' .. bg)
end

hl('StatusColor', 3, 0)

function status_line()
    return table.concat {
        '%#StatusColor#',
        ' ', 
        '%<',
        branch_name(),
        '%=',
        file_name(),
        '%=',
        '%m',
        '%y',
        ' '
    }
end

o.statusline = "%!luaeval('status_line()')"

-- << DARK AGES >> --

-- disable built-in plugins
local disabled_built_ins = {
   "2html_plugin",
   "getscript",
   "getscriptPlugin",
   "gzip",
   "logipat",
   "matchit",
   "tar",
   "tarPlugin",
   "rrhelper",
   "spellfile_plugin",
   "vimball",
   "vimballPlugin",
   "zip",
   "zipPlugin",
   "tutor",
   "rplugin",
   "synmenu",
   "optwin",
   "compiler",
   "bugreport",
   "ftplugin"
}

for _, plugin in pairs(disabled_built_ins) do
   g["loaded_" .. plugin] = 1
end

-- << RANDOM >> --

-- custom tweaking defautl theme
cmd [[highlight Comment cterm=italic ctermfg=8]]   -- italic comments
cmd [[highlight LineNr ctermfg=8]]          -- dim line numbers
cmd [[highlight EndOfBuffer ctermfg=0]]     -- dim tilde under line number
cmd [[highlight VertSplit cterm=None]]     -- remove bad split coloring
