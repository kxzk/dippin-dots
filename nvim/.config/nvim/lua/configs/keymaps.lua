local map = vim.keymap.set

-- fast saves/quit
map("n", "<leader>w", "<cmd>w!<cr>")
map("n", "<leader>q", "<cmd>q!<cr>")

-- fast searching
map("n", "<leader>s", ":%s/")

-- copy file to clipboard
map("n", "<leader>p", "<cmd>%w !pbcopy<cr><cr>")

-- clear search highlighting
map("n", "<BS>", "<cmd>nohlsearch<cr>")

-- dash app plugin
map("n", "<leader>d", "<Plug>DashSearch<cr>")

-- netrw -> nerdtree-esque
map("n", "<leader>0", "<cmd>Vexplore<cr>")

-- gitsigns
map("n", "<leader>gb", "<cmd>Gitsigns toggle_current_line_blame<cr>")
map("n", "<leader>sh", "<cmd>Gitsigns stage_hunk<cr>")
map("v", "<leader>sh", "<cmd>Gitsigns stage_hunk<cr>")

-- lsp hover
map("n", "K", function()
  vim.lsp.buf.hover({
    max_height = math.floor(vim.o.lines * 0.8),
    max_width = math.floor(vim.o.columns * 0.6),
    focusable = true,
  })
end)

-- telescope
map("n", "<leader>fg", "<cmd>Telescope live_grep<cr>")
map("n", "<leader>fc", "<cmd>Telescope git_commits<cr>")
map("n", "<leader>fb", "<cmd>Telescope git_bcommits<cr>")
