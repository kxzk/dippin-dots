vim.loader.enable()
vim.opt.shortmess:append("sI")
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.opt.termguicolors = true
vim.o.winborder = "rounded"

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins", { ui = { border = "rounded" } })

require("configs.keymaps")
require("configs.options")
require("configs.augroups")
require("configs.globals")
require("configs.colo")
require("configs.statusline")

pcall(require("telescope").load_extension, "fzf")

vim.diagnostic.config({
	virtual_lines = { current_line = true },
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "• ",
			[vim.diagnostic.severity.WARN] = "‣ ",
			[vim.diagnostic.severity.HINT] = "• ",
			[vim.diagnostic.severity.INFO] = "• ",
		},
	},
	underline = false,
	update_in_insert = false,
	severity_sort = false,
	float = {
		border = "rounded",
	},
})

-- treesitter --
require("nvim-treesitter.configs").setup({
	ensure_installed = {
		"python",
		"bash",
		"lua",
		"go",
		"rust",
		"markdown",
		"html",
		"json",
		"yaml",
		"css",
		"dockerfile",
		"sql",
		"c",
		"cpp",
		"haskell",
		"javascript",
		"glimmer",
		"ruby",
	},
	auto_install = false,
	highlight = { enable = true },
	indent = { enable = false },
})

-- lsp --
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("blink.cmp").get_lsp_capabilities(capabilities)

vim.lsp.config("*", {
	capabilities = capabilities,
	root_markers = { ".git" },
})

vim.lsp.enable({ "ty", "gopls", "ruby-lsp", "rust_analyzer" })
