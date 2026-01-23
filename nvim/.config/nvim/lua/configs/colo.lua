local function apply_highlights()
	local hl = vim.api.nvim_set_hl
	-- hl(0, "EndOfBuffer", { fg = "#101010" })
	hl(0, "@comment", { fg = "#3a4058", italic = true })
	hl(0, "Comment", { fg = "#3a4058", italic = true })
	hl(0, "MsgArea", { fg = "#3a4058" })
	hl(0, "WinSeparator", { fg = "#3a4058" })
	hl(0, "CursorLine", { bg = "#2a2e3f" })
	hl(0, "Visual", { bg = "#1c2430", fg = "#70c0f0" })
	hl(0, "FFFCursor", { bg = "#2a2e3f" })
	hl(0, "CursorLineNr", { fg = "#3a4058", bg = "#2a2e3f" })
	hl(0, "LineNr", { fg = "#3a4058" })
	hl(0, "StatusLine", { bold = false })
	hl(0, "StatusLineNC", { bold = false })
	hl(0, "@string.documentation.python", { fg = "#3a4058", italic = true })

	hl(0, "RenderMarkdownCode", { bg = "#1e2030" })
	hl(0, "RenderMarkdownCodeInline", { fg = "#ffd76d", bg = "#2a2e3f" })
	hl(0, "RenderMarkdownCodeBorder", { fg = "#ffffff", bg = "#181a28" })
	hl(0, "RenderMarkdownH1Bg", { bg = "#281820" })
	hl(0, "RenderMarkdownH2Bg", { bg = "#1e281e" })
	hl(0, "RenderMarkdownH3Bg", { bg = "#1e2038" })
	hl(0, "RenderMarkdownH1", { fg = "#d95568", bold = true })
	hl(0, "RenderMarkdownH2", { fg = "#98b860", bold = true })
	hl(0, "RenderMarkdownH3", { fg = "#6898c0", bold = true })
	hl(0, "@markup.heading.1.markdown", { fg = "#d95568", bold = false })
	hl(0, "@markup.heading.2.markdown", { fg = "#98b860", bold = false })
	hl(0, "@markup.heading.3.markdown", { fg = "#6898c0", bold = false })
	hl(0, "RenderMarkdownBullet", { fg = "#484c58" })
	hl(0, "RenderMarkdownLink", { fg = "#484c58" })
	hl(0, "RenderMarkdownQuote", { fg = "#484c58", italic = true })

	hl(0, "BlinkCmpMenu", { bg = "#2a2e3f" })
	hl(0, "BlinkCmpMenuBorder", { fg = "#3a4058" })
	hl(0, "BlinkCmpMenuSelection", { bg = "#3a4058" })
	hl(0, "BlinkCmpLabel", { fg = "#8a92b0" })
	hl(0, "BlinkCmpLabelMatch", { fg = "#c8d3f5" })
	hl(0, "BlinkCmpKind", { fg = "#3a4058" })
	hl(0, "BlinkCmpDoc", { bg = "#2a2e3f" })
	hl(0, "BlinkCmpDocBorder", { fg = "#3a4058", bg = "#2a2e3f" })
	hl(0, "BlinkCmpDocSeparator", { fg = "#3a4058", bg = "#2a2e3f" })
	hl(0, "BlinkCmpScrollBarThumb", { bg = "#3a4058" })
	hl(0, "BlinkCmpScrollBarGutter", { bg = "#2a2e3f" })

	hl(0, "TelescopeBorder", { fg = "#3a4058" })
	hl(0, "TelescopePromptBorder", { fg = "#3a4058" })
	hl(0, "TelescopeResultsBorder", { fg = "#3a4058" })
	hl(0, "TelescopePreviewBorder", { fg = "#3a4058" })

	hl(0, "FloatBorder", { fg = "#3a4058" })

	-- hl(0, "GitSignsAdd", { fg = "#B9CA4A" })
	-- hl(0, "GitSignsDelete", { fg = "#E78C45" })
	hl(0, "GitSignsChange", { fg = "#c39ac9" })
	-- hl(0, "GitSignsUntracked", { fg = "#505050" })
end

apply_highlights()

local function strip_font_styles()
	for _, group in ipairs(vim.fn.getcompletion("", "highlight")) do
		local hl = vim.api.nvim_get_hl(0, { name = group })
		local changed = false
		if hl.bold then
			hl.bold = false
			changed = true
		end
		if hl.italic and not group:lower():match("comment") then
			hl.italic = false
			changed = true
		end
		if changed then
			vim.api.nvim_set_hl(0, group, hl)
		end
	end
end

strip_font_styles()
