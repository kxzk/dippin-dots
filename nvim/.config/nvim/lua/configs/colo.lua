-- [neovim default dark]
vim.api.nvim_set_hl(0, "Comment", { fg = "#fce094", italic = true })
vim.api.nvim_set_hl(0, "EndOfBuffer", { fg = "#14161b" })
vim.api.nvim_set_hl(0, "CursorLine", { bg = "#1c1d23" })
vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#4f5258" })
vim.api.nvim_set_hl(0, "MsgArea", { fg = "#2c2e33" })
vim.api.nvim_set_hl(0, "WinSeparator", { fg = "#FFCAFF" })
vim.api.nvim_set_hl(0, "TelescopeBorder", { fg = "#2c2e33" })
vim.api.nvim_set_hl(0, "LineNr", { fg = "#2c2e33" })
vim.api.nvim_set_hl(0, "DiagnosticError", { bg = "#1c1d23" })
vim.api.nvim_set_hl(0, "DiagnosticWarn", { bg = "#1c1d23" })
vim.api.nvim_set_hl(0, "DiagnosticInfo", { bg = "#1c1d23" })
vim.api.nvim_set_hl(0, "DiagnosticHint", { bg = "#1c1d23" })
vim.api.nvim_set_hl(0, "DiagnosticVirtualTextError", { bg = "#1c1d23", fg = "#2C2E33" })
vim.api.nvim_set_hl(0, "DiagnosticVirtualTextWarn", { bg = "#1c1d23", fg = "#FFB454" })
vim.api.nvim_set_hl(0, "DiagnosticVirtualTextInfo", { bg = "#1c1d23", fg = "#A3D9FF" })
vim.api.nvim_set_hl(0, "DiagnosticVirtualTextHint", { bg = "#1c1d23", fg = "#2C2E33" })
-- vim.api.nvim_set_hl(0, "SignColumn", { fg = "#2c2e33", bg = "#1c1d23" })

-- hate those ugly ass green docstrings
vim.api.nvim_set_hl(0, "@string.documentation.python", {
	fg = "#5c6773",
	italic = true,
})
