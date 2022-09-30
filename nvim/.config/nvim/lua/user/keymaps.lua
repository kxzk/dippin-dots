-- helper for simple mappings
local function map(mode, lhs, rhs, opts)
    local options = { noremap = true, silent = true }
    if opts then
        options = vim.tbl_extend('force', options, opts)
    end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- fast saves/quit
map('n', '<leader>w', ':w!<cr>')
map('n', '<leader>q', ':q!<cr>')

-- fast searching
map('n', '<leader>s', ':%s/')

-- clear search highlighting
map('n', '<BS>', ':nohlsearch<cr>')

-- dash app plugin
map('n', '<leader>d', '<Plug>DashSearch<cr>')

-- netrw -> nerdtree-esque
map('n', '<leader>0', ':Vexplore<cr>')

-- execute shell command under cursor
-- and paste back into buffer
map('n', 'Q', '!!$SHELL<CR>')

-- telescope
map('n', '<leader>f', '<cmd>Telescope find_files<cr>')
map('n', '<leader>g', '<cmd>Telescope live_grep<cr>')
