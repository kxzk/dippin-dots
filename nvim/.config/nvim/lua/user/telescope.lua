local status_ok, teles = pcall(require, 'telescope')
if not status_ok then
    return
end

teles.setup {
    defaults = {
        prompt_prefix = '❯❯❯ ',
        selection_caret = '❯ ',
        entry_prefix = ' ',
        initial_mode = 'insert',
        -- previewer = false,
        selection_strategy = "reset",
        sorting_strategy = "ascending",
        layout_strategy = 'horizontal',
        layout_config = {
        horizontal = {
            prompt_position = 'top',
            preview_width = 0.55,
            results_width = 0.8,
        },
        vertical = {
            mirror = false,
        },
        width = 0.87,
        height = 0.80,
        preview_cutoff = 120,
        },
        file_ignore_patterns = {
            '^.git/',
            '^.cache/',
            '^__pycache__/',
            '^target/',
            '^docs/',
            'Cargo.toml',
            'Library',
            'Documents',
            '^.rustup/',
            '^.cargo/',
            '^.local/',
            '^.Trash/',
            '^pkg/',
            '%.ttf',
            '%.otf',
            '%.svg',
            '%.sqlite3',
            '%.lock',
            '%.pdf',
            '%.zip',
            '%.cache',
        },
        path_display = { 'truncate' },
        winblend = 0,
        results_title = false,
        border = {},
        borderchars = {
            prompt = { "▀", "▐", "▄", "▌", "▛", "▜", "▟", "▙" },
            results = { " ", "▐", "▄", "▌", "▌", "▐", "▟", "▙" },
            preview = { "▀", "▐", "▄", "▌", "▛", "▜", "▟", "▙" },
        }
    }
}

local exts = {
    extensions_list = { 'fzf' }
}

-- load extensions
pcall(function()
  for _, ext in ipairs(exts.extensions_list) do
    teles.load_extension(ext)
  end
end)
