vim.loader.enable()
vim.opt.shortmess:append("sI")
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0
vim.opt.termguicolors = true
vim.o.winborder = "rounded"
vim.o.pumborder = "rounded"

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

-- ui2 (experimental 0.12) --
require("vim._core.ui2").enable({})

-- treesitter (native 0.12) --
vim.api.nvim_create_autocmd("FileType", {
	callback = function()
		pcall(vim.treesitter.start)
	end,
})

-- lsp --
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("blink.cmp").get_lsp_capabilities(capabilities)

vim.lsp.config("*", {
	capabilities = capabilities,
	root_markers = { ".git" },
})

-- vim.lsp.enable({ "ty", "gopls", "ruby-lsp", "rust_analyzer", "zls" })
vim.lsp.enable({ "ty", "gopls", "rust_analyzer", "zls" })
