local map = vim.keymap.set

-- fast saves/quit
map("n", "<leader>w", ":w!<cr>")
map("n", "<leader>q", ":q!<cr>")

-- fast searching
map("n", "<leader>s", ":%s/")

-- copy file to clipboard
map("n", "<leader>p", ":%w !pbcopy<cr><cr>")

-- clear search highlighting
map("n", "<BS>", ":nohlsearch<cr>")

-- dash app plugin
map("n", "<leader>d", "<Plug>DashSearch<cr>")

-- netrw -> nerdtree-esque
map("n", "<leader>0", ":Vexplore<cr>")

-- gitsigns
map("n", "<leader>gb", "<cmd>Gitsigns toggle_current_line_blame<cr>")
map("n", "<leader>sh", "<cmd>Gitsigns stage_hunk<cr>")
map("v", "<leader>sh", "<cmd>Gitsigns stage_hunk<cr>")

-- telescope
map("n", "<leader>fg", "<cmd>Telescope live_grep<cr>")
map("n", "<leader>fr", "<cmd>Telescope lsp_references<cr>")
map("n", "<leader>fc", "<cmd>Telescope git_commits<cr>")
map("n", "<leader>fb", "<cmd>Telescope git_bcommits<cr>")
