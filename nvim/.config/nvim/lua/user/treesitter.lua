local status_ok, configs = pcall(require, "nvim-treesitter.configs")
if not status_ok then
    return
end

configs.setup {
    ensure_installed = { "python", "go", "rust", "json", "markdown", "lua" },
    sync_install = false, -- async install
    ignore_install = { "" }, -- list of parsers to install
    highlight = {
        enable = true,
        disable = { "" },
        additional_vim_regex_highligting = true,
    },
    indent = { enable = false },
}
