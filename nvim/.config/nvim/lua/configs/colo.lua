-- [gruvbox dark]
vim.api.nvim_set_hl(0, "Comment", { fg = "#3c3836", italic = true })
vim.api.nvim_set_hl(0, "CursorLine", { bg = default })
vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#3c3836", bg = default })
vim.api.nvim_set_hl(0, "LineNr", { fg = "#3c3836" })
vim.api.nvim_set_hl(0, "MsgArea", { fg = "#282828" })
vim.api.nvim_set_hl(0, "EndOfBuffer", { fg = "#282828" })
vim.api.nvim_set_hl(0, "SignColumn", { bg = "#282828" })
vim.api.nvim_set_hl(0, "TelescopeNormal", { fg = "#504945" })
vim.api.nvim_set_hl(0, "WinSeparator", { fg = "#b8bb26" })

-- better docstrigns
vim.api.nvim_set_hl(0, "@string.documentation.python", {
	fg = "#3c3836",
	italic = true,
})

vim.api.nvim_set_hl(0, "SpellBad", { undercurl = true, sp = "#FF4444" })
vim.api.nvim_set_hl(0, "SpellCap", { undercurl = true, sp = "#D97700" })
vim.api.nvim_set_hl(0, "SpellLocal", { undercurl = true, sp = "#6B7D6A" })
vim.api.nvim_set_hl(0, "SpellRare", { undercurl = true, sp = "#8B7D8B" })
