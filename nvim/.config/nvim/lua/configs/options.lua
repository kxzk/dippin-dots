local opt = vim.opt

-- [[ UI ]] --

opt.cursorline = true
opt.number = true
opt.relativenumber = true
opt.showmatch = true -- highlight matching parens
opt.ignorecase = true -- ignore case when searching
opt.conceallevel = 0 -- make `` visible in markdown files
opt.showmode = false -- remove annoying -- INSERT -- commands at bottom
opt.showcmd = false -- do not show partial command in last line
opt.splitbelow = true
opt.splitright = true

-- get rid of annoying split chars
opt.fillchars = {
	horiz = "━",
	horizup = " ",
	horizdown = " ",
	vert = " ",
	vertleft = " ",
	vertright = " ",
	verthoriz = " ",
}

-- [[ CORE ]] --

opt.syntax = "on" -- syntax highlighting on, duh
opt.laststatus = 3 -- global statusline
opt.completeopt = "menuone,noinsert,noselect" -- autocomplete options
opt.mouse = "a" -- turn on mouse support
opt.scrolloff = 3 -- min lines to keep above/below cursor
opt.foldmethod = "manual" -- manual folding -> zf{motion}, zo -> open, zc -> close

-- set omnifunc=syntaxcomplete#Complete

-- [[ INDENT ]] --

opt.expandtab = true -- spaces instead of tabs
opt.shiftwidth = 2 -- shift 4 spaces when tab
opt.tabstop = 2 -- 1 tab == 4 spaces
opt.smartindent = true
opt.shiftround = true -- round indent to multiple of shiftwidth

-- [[ PERF ]] --

opt.hidden = true -- enable background buffers
opt.history = 50 -- remember n commands :example
opt.lazyredraw = true -- faster scrolling
opt.backup = false -- no backups
opt.writebackup = false -- no backups while editing (living on the edge)
opt.swapfile = false -- no swapfile
opt.updatecount = 0 -- no swapfiles after some number of updates
opt.updatetime = 50 -- less lag
