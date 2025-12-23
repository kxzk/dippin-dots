local function apply_highlights()
	local hl = vim.api.nvim_set_hl
	hl(0, "@comment", { fg = "#3a4058", italic = true })
	hl(0, "Comment", { fg = "#3a4058", italic = true })
	hl(0, "MsgArea", { fg = "#3a4058" })
	hl(0, "WinSeparator", { fg = "#3a4058" })
	hl(0, "CursorLine", { bg = "#2a2e3f" })
	hl(0, "FFFCursor", { bg = "#2a2e3f" })
	hl(0, "CursorLineNr", { fg = "#3a4058", bg = "#2a2e3f" })
	hl(0, "LineNr", { fg = "#3a4058" })
	hl(0, "StatusLine", { bold = false })
	hl(0, "StatusLineNC", { bold = false })
	hl(0, "@string.documentation.python", { fg = "#3a4058", italic = true })

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

	-- hl(0, "CopilotSuggestion", { fg = "#3a4058" })

	hl(0, "TelescopeBorder", { fg = "#3a4058" })
	hl(0, "TelescopePromptBorder", { fg = "#3a4058" })
	hl(0, "TelescopeResultsBorder", { fg = "#3a4058" })
	hl(0, "TelescopePreviewBorder", { fg = "#3a4058" })

	hl(0, "NormalFloat", { bg = "#2a2e3f" })
	hl(0, "FloatBorder", { fg = "#3a4058", bg = "#2a2e3f" })
end

apply_highlights()

-- Strip italics from all highlight groups except comments.
-- Many colorschemes overuse italics which reduces readability.
local function strip_italics()
	for _, group in ipairs(vim.fn.getcompletion("", "highlight")) do
		if not group:lower():match("comment") then
			local hl = vim.api.nvim_get_hl(0, { name = group })
			if hl.italic then
				hl.italic = false
				vim.api.nvim_set_hl(0, group, hl)
			end
		end
	end
end

strip_italics()

vim.api.nvim_create_autocmd("ColorScheme", {
	callback = function()
		apply_highlights()
		strip_italics()
	end,
})
