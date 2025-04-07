vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = { "*.go" },
	callback = function()
		vim.lsp.buf.code_action({ context = { only = { "source.organizeImports" } }, apply = true })
		-- vim.lsp.buf.format()
		-- vim.cmd [[silent! golines -m 100 -w %]]
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "gitcommit", "markdown" },
	callback = function()
		vim.opt_local.spell = true
		vim.opt_local.relativenumber = true
		-- vim.opt_local.textwidth = 72
	end,
})

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if client:supports_method("textDocument/completion") then
			vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
		end
	end,
})

vim.cmd([[
   augroup _python
       autocmd!
       autocmd Filetype python nmap <leader>r :20 split term://uv run %<CR>
   augroup end

   augroup _html
        autocmd!
        autocmd Filetype html nmap <leader>ts :TailwindSort<CR>
   augroup end

   augroup _go
       autocmd!
       autocmd Filetype go nmap <leader>r :20 split term://go run *.go<CR>
       " autocmd BufWritePost *.go !golines -m 100 -w % 
   augroup end

    augroup _rust
        autocmd!
        autocmd Filetype rust nmap <leader>r :20 split term://cargo run<CR>
        autocmd Filetype rust nmap <leader>t :20 split term://cargo test<CR>
    augroup end

    augroup _templates
        autocmd!
        autocmd BufNewFile *.py 0r ~/.config/nvim/templates/py.skeleton
        autocmd BufNewFile *.go 0r ~/.config/nvim/templates/go.skeleton
        autocmd BufNewFile *.todo 0r ~/.config/nvim/templates/todo.skeleton
    augroup end

    augroup _sql
        autocmd!
        autocmd Filetype sql :colorscheme retrobox
        " autocmd Filetype sql nmap <leader>r :20 split term://snowsql -f %<CR>
        autocmd Filetype sql nmap <leader>r :20 split term://duckdb \< %<CR>
        autocmd Filetype sql nmap <leader>t :!sqlfmt %<CR><CR>
    augroup end

    augroup _terminal
        autocmd!
        autocmd TermOpen * setlocal nonumber norelativenumber
    augroup end
]])
