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

-- << PACKAGES >> --

-- ensure packer is installed
local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

require('packer').startup(function(use)
    use 'wbthomason/packer.nvim'

    use {
        'lewis6991/gitsigns.nvim',
        config = function()
            require('gitsigns').setup()
        end
    }

    -- lsp config + installer
    -- use 'neovim/nvim-lspconfig'

    -- use {
        -- 'nvim-telescope/telescope.nvim',
        -- opt = true,
        -- cmd = 'Telescope',
        -- tag = '0.1.0',
        -- requires = { {'nvim-lua/plenary.nvim'} }
    -- }

    -- scala lsp
    -- use {'scalameta/nvim-metals', requires = { 'nvim-lua/plenary.nvim' } }

    -- lazy load for specific command
    use { 'psf/black', opt = true, cmd = 'Black' }   -- make sure to install `pynvim`
    use 'scrooloose/nerdcommenter'  -- commenting
    use 'rizzatti/dash.vim'         -- dash app plugin

    if packer_bootstrap then
        require('packer').sync()
    end
end)

-- << REQUIRE >> --

-- require('lua.plugins.telescope')

-- << OPTIONS >> --

g.mapleader = ' '           -- space leader
g.background = 'dark'
g.do_filetype_lua = 1

cmd [[colorscheme default]]

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

-- get rid of annoying split chars
opt.fillchars = {
  horiz = '-',
  horizup = ' ',
  horizdown = ' ',
  vert = ' ',
  vertleft  = ' ',
  vertright = ' ',
  verthoriz = ' ',
}

-- [[ CORE ]] --

opt.syntax = 'on'           -- syntax highlighting on, duh
opt.laststatus = 3          -- global statusline
opt.completeopt = 'menuone,noinsert,noselect'   -- autocomplete options
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

-- [[ PLUGOPTS ]] --

if (vim.loop.os_uname().sysnem == 'Darwin') then
    g.python3_host_prog = '/opt/homebrew/bin/python3'
else
    g.python3_host_prog = '/usr/bin/python3'
end

g.black_fast = 1
g.NERDSpaceDelims = 1
g.NERDTrimTrailingWhitespace = 1

-- << TEMPLATES >> --

cmd [[
    augroup Templates
        autocmd!
        autocmd BufNewFile *.py 0r ~/.config/nvim/templates/py.skeleton
        autocmd BufNewFile *.go 0r ~/.config/nvim/templates/go.skeleton
        autocmd BufNewFile *.todo 0r ~/.config/nvim/templates/todo.skeleton
    augroup END
]]

-- << PYTHON >> --

-- @TODO: replace this with lua way
cmd [[
   augroup PyOpts
       autocmd!
       autocmd Filetype python nmap <leader>r :split term://python3 %<CR>
       autocmd BufWritePre *.py silent execute ':Black'
   augroup END
]]

-- << GOLANG >> --

cmd [[
   augroup GoOpts
       autocmd!
       autocmd Filetype go nmap <leader>r :split term://go run *.go<CR>
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

-- fast saves/quit
map('n', '<leader>w', ':w!<CR>')
map('n', '<leader>q', ':q!<CR>')

-- breaks my brain othwerwise
map('n', 'Y', 'yy')

-- fast searching
map('n', '<leader>s', ':%s/')

-- clear search highlighting
map('n', '<BS>', ':nohl<CR>')

-- dash app plugin
map('n', '<leader>d', '<Plug>DashSearch<CR>')

-- netrw -> nerdtree-esque
map('n', '<leader>0', ':Vexplore<CR>')

-- execute shell command under cursor
-- and paste back into buffer
map('n', 'Q', '!!$SHELL<CR>')

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
   "ftplugin",
}

for _, plugin in pairs(disabled_built_ins) do
   g["loaded_" .. plugin] = 1
end

-- << RANDOM >> --

-- custom tweaking defautl theme
cmd [[highlight Comment ctermfg=8]]         -- italic comments
cmd [[highlight LineNr ctermfg=8]]          -- dim line numbers
cmd [[highlight EndOfBuffer ctermfg=0 cterm=italic]]     -- dim tilde under line number
cmd [[highlight VertSplit ctermfg=3 cterm=None ctermbg=None]]      -- remove bad split coloring
cmd [[highlight SignColumn ctermbg=None]]   -- remove bad sign column coloring
cmd [[highlight MsgArea ctermfg=8]]         -- dim command line/message area
cmd [[highlight GitSignsAdd ctermfg=2]]     -- default colo doesn't set these
cmd [[highlight GitSignsDelete ctermfg=1]]
cmd [[highlight GitSignsChange ctermfg=5]]
