local M = {}

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
function M.on_attach(_, bufnr)
    -- Enable completion triggered by <c-x><c-o>
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    local bufopts = { noremap=true, silent=true, buffer=bufnr }

    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
    vim.keymap.set('n', '[x', '<Cmd>lua vim.diagnostic.goto_prev()<CR>', bufopts)
    vim.keymap.set('n', ']x', '<Cmd>lua vim.diagnostic.goto_next()<CR>', bufopts)
    vim.keymap.set('n', ']r', '<Cmd>lua vim.diagnostic.open_float()<CR>', bufopts)
    vim.keymap.set('n', ']s', '<Cmd>lua vim.diagnostic.show()<CR>', bufopts)

    vim.api.nvim_create_autocmd('BufWritePre', {
        pattern = {'*'},
        command = [[lua vim.lsp.buf.formatting_sync()]]
    })
end

return M
