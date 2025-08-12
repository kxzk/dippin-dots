return {
	{
		"MeanderingProgrammer/render-markdown.nvim",
	},
	{
		"dmtrKovalenko/fff.nvim",
		build = "cargo build --release",
		opts = {
			prompt = " ",
			keymaps = {
				close = "<C-c>",
			},
			icons = {
				enabled = false,
			},
		},
		keys = {
			{
				"ff",
				function()
					require("fff").find_files()
				end,
				desc = "Open file picker",
			},
		},
	},
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		opts = {
			styles = {
				keywords = { italic = false },
				functions = { italic = false },
				variables = { italic = false },
			},
		},
	},
	{
		"lewis6991/gitsigns.nvim",
		opts = {
			signs = {
				add = { text = "▎" },
				change = { text = "▎" },
				delete = { text = "▎" },
				topdelete = { text = "▎" },
				changedelete = { text = "▎" },
				untracked = { text = "¦" },
			},
		},
	},
	{ "github/copilot.vim" },
	{ "rizzatti/dash.vim", event = "VeryLazy" },
	-- Fuzzy Finder (files, lsp, etc)
	{
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			-- Fuzzy Finder Algorithm which requires local dependencies to be built.
			-- Only load if `make` is available. Make sure you have the system
			-- requirements installed.
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				-- NOTE: If you are having trouble with this installation,
				--       refer to the README for telescope-fzf-native for more instructions.
				build = "make",
				cond = function()
					return vim.fn.executable("make") == 1
				end,
			},
		},
		opts = {
			defaults = {
				prompt_prefix = "  ",
				selection_caret = " ",
				entry_prefix = " ",
				initial_mode = "insert",
				selection_strategy = "reset",
				sorting_strategy = "ascending",
				layout_strategy = "horizontal",
				layout_config = {
					horizontal = {
						prompt_position = "top",
						preview_width = 0.55,
						results_width = 0.8,
					},
					vertical = {
						mirror = false,
					},
				},
				file_ignore_patterns = {
					"^.git/",
					"^.cache/",
					"^__pycache__/",
					"^target/",
					"^docs/",
					"Cargo.toml",
					"Library",
					"Documents",
					"^.rustup/",
					"^.cargo/",
					"^.local/",
					"^.Trash/",
					"^pkg/",
					"%.ttf",
					"%.otf",
					"%.svg",
					"%.sqlite3",
					"%.lock",
					"%.pdf",
					"%.zip",
					"%.cache",
				},
				path_display = { "truncate" },
				winblend = 0,
				results_title = false,
				preview_title = false,
				borderchars = {
					{ "─", "│", "─", "│", "┌", "┐", "┘", "└" },
					prompt = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
					results = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
					preview = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
				},
			},
		},
	},
	{
		-- Highlight, edit, and navigate code
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		opts = {
			indent = { enable = false },
		},
	},
	-- {
	-- 	"laytan/tailwind-sorter.nvim",
	-- 	dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-lua/plenary.nvim" },
	-- 	build = "cd formatter && npm i && npm run build",
	-- 	config = true,
	-- 	ft = "html",
	-- 	opts = {
	-- 		on_save_enabled = true,
	-- 		on_save_pattern = { "*.html", "*.templ" },
	-- 	},
	-- },
	{
		"stevearc/conform.nvim",
		opts = {
			formatters_by_ft = {
				lua = { "stylua" },
				go = { "goimports", "gofmt", "golines" },
				cpp = { "clang-format" },
				python = { "ruff_format", "ruff_organize_imports" },
				-- javascript = { "prettierd" },
				html = { "prettierd" },
				fish = { "fish_indent" },
				rust = { "rustfmt" },
				zig = { "zigfmt" },
				-- sql = { "sqlfmt" },
				["_"] = { "trim_whitespace" },
			},
			formatters = {
				zigfmt = {
					command = "zig",
					args = { "fmt", "--stdin" },
					stdin = true,
					stdout = true,
				},
			},
			format_on_save = {
				timeout_ms = 500,
				lsp_fallback = true,
			},
		},
	},
	{
		"saghen/blink.cmp",
		version = "1.*",
		opts = {
			-- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
			-- 'super-tab' for mappings similar to vscode (tab to accept)
			-- 'enter' for enter to accept
			--
			-- All presets have the following mappings:
			-- C-space: Open menu or open docs if already open
			-- C-n/C-p or Up/Down: Select next/previous item
			-- C-e: Hide menu
			-- C-k: Toggle signature help (if signature.enabled = true)
			--
			-- See :h blink-cmp-config-keymap for defining your own keymap
			keymap = {
				preset = "default",
				["<C-w>"] = { "scroll_documentation_up" },
				["<C-e>"] = { "scroll_documentation_down" },
			},
			appearance = { nerd_font_variant = "Nerd Font Mono" },
			completion = { documentation = { auto_show = false } },
			signature = { enabled = true },
			sources = { default = { "lsp", "path", "snippets", "buffer" } },
			fuzzy = { implementation = "prefer_rust_with_warning" },
		},
		opts_extend = { "sources.default" },
	},
}
