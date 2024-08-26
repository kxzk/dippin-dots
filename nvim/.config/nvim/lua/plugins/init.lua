return {
	{
		"lewis6991/gitsigns.nvim",
		opts = {
			signs = {
				add = { text = "|" },
				change = { text = "+" },
				delete = { text = "×" },
				topdelete = { text = "×" },
				changedelete = { text = "×" },
				untracked = { text = "¦" },
			},
		},
	},
	{ "github/copilot.vim", tag = "v1.38.0" },
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
				prompt_prefix = "❯❯❯ ",
				selection_caret = "❯ ",
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
	{
		-- LSP Configuration & Plugins
		"neovim/nvim-lspconfig",
		dependencies = {
			-- Automatically install LSPs to stdpath for neovim
			{ "williamboman/mason.nvim", config = true },
			"williamboman/mason-lspconfig.nvim",
		},
	},
	{
		"laytan/tailwind-sorter.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-lua/plenary.nvim" },
		build = "cd formatter && npm i && npm run build",
		config = true,
		ft = "html",
		opts = {
			on_save_enabled = true,
			on_save_pattern = { "*.html", "*.templ" },
		},
	},
	{
		"stevearc/conform.nvim",
		opts = {
			formatters_by_ft = {
				lua = { "stylua" },
				go = { "goimports", "gofmt", "golines" },
				cpp = { "clang-format" },
				python = { "isort", "black" },
				-- javascript = { "prettierd" },
				html = { "prettierd" },
				fish = { "fish_indent" },
				rust = { "rustfmt" },
				-- sql = { "sqlfmt" },
				["_"] = { "trim_whitespace" },
			},
			format_on_save = {
				timeout_ms = 500,
				lsp_fallback = true,
			},
		},
	},
	{
		"yetone/avante.nvim",
		event = "VeryLazy",
		build = "make",
		opts = {
			-- add any opts here
		},
		dependencies = {
			"nvim-tree/nvim-web-devicons",
			"stevearc/dressing.nvim",
			"nvim-lua/plenary.nvim",
			{
				"grapp-dev/nui-components.nvim",
				dependencies = {
					"MunifTanjim/nui.nvim",
				},
			},
		},
	},
}
