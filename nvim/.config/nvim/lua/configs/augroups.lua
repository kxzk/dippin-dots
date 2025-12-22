local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

augroup("go", { clear = true })
autocmd("FileType", {
	group = "go",
	pattern = "go",
	callback = function()
		vim.keymap.set("n", "<leader>r", ":20 split term://go run *.go<CR>", { buffer = true })
	end,
})

augroup("markdown", { clear = true })
autocmd("FileType", {
	group = "markdown",
	pattern = { "gitcommit", "markdown" },
	callback = function()
		vim.opt_local.relativenumber = true
	end,
})

augroup("ruby", { clear = true })
autocmd("FileType", {
	group = "ruby",
	pattern = "ruby",
	callback = function()
		vim.keymap.set("n", "<leader>r", ":20 split term://ruby %<CR>", { buffer = true })
	end,
})

augroup("python", { clear = true })
autocmd("FileType", {
	group = "python",
	pattern = "python",
	callback = function()
		vim.keymap.set("n", "<leader>r", ":20 split term://uv run %<CR>", { buffer = true })
	end,
})

augroup("html", { clear = true })
autocmd("FileType", {
	group = "html",
	pattern = "html",
	callback = function()
		vim.keymap.set("n", "<leader>ts", ":TailwindSort<CR>", { buffer = true })
	end,
})

augroup("rust", { clear = true })
autocmd("FileType", {
	group = "rust",
	pattern = "rust",
	callback = function()
		vim.keymap.set("n", "<leader>r", ":20 split term://cargo run<CR>", { buffer = true })
		vim.keymap.set("n", "<leader>t", ":20 split term://cargo test<CR>", { buffer = true })
	end,
})

augroup("zig", { clear = true })
autocmd("FileType", {
	group = "zig",
	pattern = "zig",
	callback = function()
		vim.keymap.set("n", "<leader>r", function()
			local output = vim.fn.system("zig run " .. vim.fn.expand("%"))
			print(output)
		end, { buffer = true })
	end,
})

augroup("templates", { clear = true })
autocmd("BufNewFile", {
	group = "templates",
	pattern = "*.prd",
	command = "0r ~/.config/nvim/templates/prd.skeleton",
})
autocmd("BufNewFile", {
	group = "templates",
	pattern = "*.py",
	command = "0r ~/.config/nvim/templates/py.skeleton",
})
autocmd("BufNewFile", {
	group = "templates",
	pattern = "*.go",
	command = "0r ~/.config/nvim/templates/go.skeleton",
})
autocmd("BufNewFile", {
	group = "templates",
	pattern = "*.todo",
	command = "0r ~/.config/nvim/templates/todo.skeleton",
})

augroup("sql", { clear = true })
autocmd("FileType", {
	group = "sql",
	pattern = "sql",
	callback = function()
		vim.keymap.set("n", "<leader>r", ":20 split term://duckdb < %<CR>", { buffer = true })
		vim.keymap.set("n", "<leader>t", ":!sqlfmt %<CR><CR>", { buffer = true })
	end,
})

augroup("terminal", { clear = true })
autocmd("TermOpen", {
	group = "terminal",
	pattern = "*",
	callback = function()
		vim.opt_local.number = false
		vim.opt_local.relativenumber = false
	end,
})

augroup("highlight_yank", { clear = true })
autocmd("TextYankPost", {
	group = "highlight_yank",
	callback = function()
		vim.hl.on_yank({ higroup = "Visual", timeout = 200 })
	end,
})
