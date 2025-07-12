-- [neovim default dark]

local colors = {
	-- special colors
	stealth = "#5C6773",
	subtle_bg = "#1c1d23",
	error_red = "#df616d",
	-- dark colors
	dark_blue = "#004c63",
	dark_cyan = "#007373",
	dark_green = "#005523",
	dark_magenta = "#470045",
	dark_red = "#590008",
	dark_yellow = "#6b5300",
	-- light colors
	light_blue = "#A6DBFF",
	light_cyan = "#8cf8f7",
	light_green = "#b4f6c0",
	light_magenta = "#FFCAFF",
	light_red = "#FFC0B9",
	light_yellow = "#FCE094",
	-- greys
	light_grey1 = "#EEF1F8",
	light_grey2 = "#E0E2EA",
	light_grey3 = "#C4C6CD",
	light_grey4 = "#9b9ea4",
	dark_grey4 = "#4f5258",
	dark_grey3 = "#2c2e33",
	dark_grey2 = "#14161B",
	dark_grey1 = "#07080D",
}

-- basics
vim.api.nvim_set_hl(0, "Comment", { fg = colors.light_yellow, italic = true })
vim.api.nvim_set_hl(0, "EndOfBuffer", { fg = colors.dark_grey2 })
vim.api.nvim_set_hl(0, "CursorLine", { bg = colors.subtle_bg })
vim.api.nvim_set_hl(0, "CursorLineNr", { fg = colors.dark_grey4, bg = colors.subtle_bg })
vim.api.nvim_set_hl(0, "MsgArea", { fg = colors.dark_grey3 })
vim.api.nvim_set_hl(0, "WinSeparator", { fg = colors.light_magenta })
vim.api.nvim_set_hl(0, "LineNr", { fg = colors.dark_grey3 })

-- search
vim.api.nvim_set_hl(0, "Search", { fg = colors.dark_grey1, bg = colors.light_grey3 })
vim.api.nvim_set_hl(0, "IncSearch", { fg = colors.dark_grey1, bg = colors.light_yellow })
vim.api.nvim_set_hl(0, "CurSearch", { link = "IncSearch" })

-- diagnostics
vim.api.nvim_set_hl(0, "DiagnosticError", { fg = colors.error_red })
vim.api.nvim_set_hl(0, "DiagnosticWarn", { fg = colors.light_yellow })
vim.api.nvim_set_hl(0, "DiagnosticInfo", { fg = colors.light_blue })
vim.api.nvim_set_hl(0, "DiagnosticHint", { fg = colors.light_green })

-- diagnostic virtual text
vim.api.nvim_set_hl(0, "DiagnosticVirtualTextError", { fg = colors.error_red })
vim.api.nvim_set_hl(0, "DiagnosticVirtualTextWarn", { fg = colors.light_yellow })
vim.api.nvim_set_hl(0, "DiagnosticVirtualTextInfo", { fg = colors.light_blue })
vim.api.nvim_set_hl(0, "DiagnosticVirtualTextHint", { fg = colors.light_green })

-- diagnostic signs
vim.api.nvim_set_hl(0, "DiagnosticSignError", { fg = colors.error_red })
vim.api.nvim_set_hl(0, "DiagnosticSignWarn", { fg = colors.light_yellow })
vim.api.nvim_set_hl(0, "DiagnosticSignInfo", { fg = colors.light_blue })
vim.api.nvim_set_hl(0, "DiagnosticSignHint", { fg = colors.light_green })

-- spelling errors
vim.api.nvim_set_hl(0, "SpellBad", { undercurl = true, sp = colors.error_red })
vim.api.nvim_set_hl(0, "SpellCap", { undercurl = true, sp = "#e36209" })
vim.api.nvim_set_hl(0, "SpellLocal", { undercurl = true, sp = "#032f62" })
vim.api.nvim_set_hl(0, "SpellRare", { undercurl = true, sp = "#6f42c1" })

-- python
vim.api.nvim_set_hl(0, "@string.documentation.python", {
	fg = colors.dark_grey3,
	italic = true,
})

-- markdown
vim.api.nvim_set_hl(0, "@markup.heading", { fg = colors.light_blue, bold = true })
vim.api.nvim_set_hl(0, "@markup.heading.1", { fg = colors.light_yellow, bold = true })
vim.api.nvim_set_hl(0, "@markup.heading.2", { fg = colors.light_yellow, bold = true })
vim.api.nvim_set_hl(0, "@markup.heading.3", { fg = colors.light_green, bold = true })
vim.api.nvim_set_hl(0, "@markup.heading.4", { fg = colors.light_cyan, bold = true })
vim.api.nvim_set_hl(0, "@markup.heading.5", { fg = colors.light_magenta, bold = true })
vim.api.nvim_set_hl(0, "@markup.heading.6", { fg = colors.light_blue, bold = true })
vim.api.nvim_set_hl(0, "@markup.raw", { fg = colors.light_green, bg = colors.dark_grey2 })
vim.api.nvim_set_hl(0, "@markup.raw.block", { fg = colors.light_green, bg = colors.dark_grey2 })
vim.api.nvim_set_hl(0, "@markup.link", { fg = colors.light_blue, underline = true })
vim.api.nvim_set_hl(0, "@markup.link.url", { fg = colors.dark_blue, italic = true })
vim.api.nvim_set_hl(0, "@markup.list", { fg = colors.light_yellow })
vim.api.nvim_set_hl(0, "@markup.list.checked", { fg = colors.light_green })
vim.api.nvim_set_hl(0, "@markup.list.unchecked", { fg = colors.light_grey4 })
vim.api.nvim_set_hl(0, "@markup.italic", { italic = true })
vim.api.nvim_set_hl(0, "@markup.strong", { bold = true })
vim.api.nvim_set_hl(0, "@markup.strikethrough", { strikethrough = true })

-- telescope
vim.api.nvim_set_hl(0, "TelescopeNormal", { fg = colors.light_grey2 })
vim.api.nvim_set_hl(0, "TelescopePromptNormal", { fg = colors.light_grey1 })
vim.api.nvim_set_hl(0, "TelescopeResultsNormal", { fg = colors.light_grey3 })
vim.api.nvim_set_hl(0, "TelescopePreviewNormal", { fg = colors.light_grey2 })
vim.api.nvim_set_hl(0, "TelescopePromptBorder", { fg = colors.dark_grey3 })
vim.api.nvim_set_hl(0, "TelescopeResultsBorder", { fg = colors.dark_grey3 })
vim.api.nvim_set_hl(0, "TelescopePreviewBorder", { fg = colors.dark_grey3 })
vim.api.nvim_set_hl(0, "TelescopePromptTitle", { fg = colors.dark_grey3 })
vim.api.nvim_set_hl(0, "TelescopeResultsTitle", { fg = colors.light_blue })
vim.api.nvim_set_hl(0, "TelescopePreviewTitle", { fg = colors.dark_grey3 })
vim.api.nvim_set_hl(0, "TelescopeSelection", { fg = colors.light_grey1, bg = colors.subtle_bg })
vim.api.nvim_set_hl(0, "TelescopeSelectionCaret", { fg = colors.light_blue, bg = colors.subtle_bg })
vim.api.nvim_set_hl(0, "TelescopeMultiSelection", { fg = colors.light_yellow, bg = colors.subtle_bg })
vim.api.nvim_set_hl(0, "TelescopeMatching", { fg = colors.light_cyan, bold = true })
vim.api.nvim_set_hl(0, "TelescopePromptPrefix", { fg = colors.light_blue })
