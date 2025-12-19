local function apply_highlights()
	local hl = vim.api.nvim_set_hl
	hl(0, "@comment", { fg = "#3a4058", italic = true })
	hl(0, "Comment", { fg = "#3a4058", italic = true })
	hl(0, "MsgArea", { fg = "#3a4058" })
	hl(0, "WinSeparator", { fg = "#3a4058" })
	hl(0, "CursorLine", { bg = "#2a2e3f" })
	hl(0, "CursorLineNr", { fg = "#3a4058" })
	hl(0, "LineNr", { fg = "#3a4058" })
	hl(0, "StatusLine", { bold = false })
	hl(0, "StatusLineNC", { bold = false })
	hl(0, "@string.documentation.python", { fg = "#3a4058", italic = true })
end

apply_highlights()

vim.api.nvim_create_autocmd("ColorScheme", {
	callback = apply_highlights,
})
