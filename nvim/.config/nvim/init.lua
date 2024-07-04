vim.opt.shortmess:append("sI")
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.opt.termguicolors = true

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
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

require("configs.colo")
require("configs.keymaps")
require("configs.statusline")
require("configs.options")
require("configs.augroups")
require("configs.globals")

pcall(require("telescope").load_extension, "fzf")

-- signs --

vim.diagnostic.config({
	virtual_text = true,
	signs = true,
	underline = false,
	update_in_insert = false,
	severity_sort = false,
	float = {
		border = "rounded",
	},
})

-- configure specific sign symbols
local signs = { Error = "• ", Warn = "‣ ", Hint = "• ", Info = "• " }

for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- treesitter --

require("nvim-treesitter.configs").setup({
	ensure_installed = {
		"python",
		"bash",
		"lua",
		"go",
		"rust",
		"elixir",
		"fish",
		"markdown",
		"html",
		"json",
		"yaml",
		"css",
		"dockerfile",
		"sql",
		"swift",
		"c",
		"cpp",
		"terraform",
		"ruby",
	},
	auto_install = false,
	highlight = { enable = true },
	indent = { enable = false },
})

-- lsp --

-- servers --

local servers = {
	pyright = {},
	gopls = {
		settings = {
			gopls = {
				gofumpt = true,
			},
		},
	},
	-- elixirls = {},
	clangd = {},
	-- solargraph = {
	-- 	definitions = true,
	-- 	references = true,
	-- 	diagnostics = true,
	-- },
}

local on_attach = function(client, bufnr)
	local nmap = function(keys, func, desc)
		if desc then
			desc = "LSP: " .. desc
		end

		vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
	end

	-- nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
	-- nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
	nmap("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
	nmap("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
	nmap("gi", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
	nmap("<leader>T", vim.lsp.buf.type_definition, "Type [D]efinition")
	-- nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
	-- nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
	nmap("K", vim.lsp.buf.hover, "Hover Documentation")
	nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")
	nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
	-- nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
	-- nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')

	client.server_capabilities.semanticTokensProvider = nil
end

local capabilities = vim.lsp.protocol.make_client_capabilities()

-- mason --

local mason_lspconfig = require("mason-lspconfig")

mason_lspconfig.setup({
	ensure_installed = vim.tbl_keys(servers),
})

mason_lspconfig.setup_handlers({
	function(server_name)
		require("lspconfig")[server_name].setup({
			capabilities = capabilities,
			on_attach = on_attach,
			settings = servers[server_name],
			filetypes = (servers[server_name] or {}).filetypes,
		})
	end,
})
