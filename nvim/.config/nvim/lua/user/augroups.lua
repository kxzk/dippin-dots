vim.cmd [[
   augroup _python
       autocmd!
       autocmd Filetype python nmap <leader>r :20 split term://python3 %<CR>
       autocmd BufWritePre *.py silent execute ':Black'
   augroup end

   augroup _go
       autocmd!
       autocmd Filetype go nmap <leader>r :20 split term://go run *.go<CR>
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

    augroup _writing
        autocmd!
        autocmd Filetype markdown setlocal spell
    augroup end

    augroup _git
        autocmd!
        autocmd Filetype gitcommit setlocal spell relativenumber textwidth=72
    augroup end

    augroup _sql
        autocmd!
        autocmd Filetype sql nmap <leader>r :20 split term://snowsql -f %<CR>
        autocmd Filetype sql nmap <leader>t :!sqlfmt %<CR><CR>
    augroup end

    augroup _terminal
        autocmd!
        autocmd TermOpen * setlocal nonumber norelativenumber
    augroup end
]]
