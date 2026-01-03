local function apply_highlights()
	local hl = vim.api.nvim_set_hl
	hl(0, "EndOfBuffer", { fg = "#101010" })
	hl(0, "@comment", { fg = "#72adf9", italic = true })
	hl(0, "Comment", { fg = "#72adf9", italic = true })
	hl(0, "MsgArea", { fg = "#282828" })
	hl(0, "WinSeparator", { fg = "#282828" })
	hl(0, "CursorLine", { bg = "#161616" })
	hl(0, "Visual", { bg = "#161616", fg = "#ff7300" })
	hl(0, "FFFCursor", { bg = "#161616" })
	hl(0, "CursorLineNr", { fg = "#282828", bg = "#161616" })
	hl(0, "LineNr", { fg = "#282828" })
	hl(0, "StatusLine", { bold = false })
	hl(0, "StatusLineNC", { bold = false })
	hl(0, "@string.documentation.python", { fg = "#282828", italic = true })

	-- hl(0, "RenderMarkdownCode", { bg = "#232323" })
	-- hl(0, "RenderMarkdownH1", { fg = "#FF8080", bold = false })
	-- hl(0, "RenderMarkdownH1Bg", { bg = "#282828" })
	-- hl(0, "RenderMarkdownH3", { fg = "#FFCFA8", bold = false })
	-- hl(0, "RenderMarkdownH3Bg", { bg = "#282828" })
	-- hl(0, "@markup.heading.1.markdown", { fg = "#99FFE4", bold = false })
	-- hl(0, "@markup.heading.3.markdown", { fg = "#FFCFA8", bold = false })

	-- Menu container: use bgDarker, barely visible border
	hl(0, "BlinkCmpMenu", { bg = "#1a1a1a" }) -- between bg and bgDark
	hl(0, "BlinkCmpMenuBorder", { fg = "#1a1a1a" }) -- blend into menu, nearly invisible
	-- Selection: subtle lift, not a spotlight
	hl(0, "BlinkCmpMenuSelection", { bg = "#282828" }) -- bgFloat, gentler than #343434
	-- Labels: muted base, match uses fg not white
	hl(0, "BlinkCmpLabel", { fg = "#505050" }) -- fgDisabled, very quiet
	hl(0, "BlinkCmpLabelMatch", { fg = "#A0A0A0" }) -- primary, NOT white
	-- Kind icons: near-invisible, just enough to parse
	hl(0, "BlinkCmpKind", { fg = "#3a3a3a" }) -- darker than current
	-- Documentation panel: continuous with menu
	hl(0, "BlinkCmpDoc", { bg = "#1a1a1a" })
	hl(0, "BlinkCmpDocBorder", { fg = "#282828", bg = "#1a1a1a" })
	hl(0, "BlinkCmpDocSeparator", { fg = "#282828", bg = "#1a1a1a" })
	-- Scrollbar: barely there
	hl(0, "BlinkCmpScrollBarThumb", { bg = "#2a2a2a" })
	hl(0, "BlinkCmpScrollBarGutter", { bg = "#1a1a1a" })

	hl(0, "TelescopeBorder", { fg = "#161616" })
	hl(0, "TelescopePromptBorder", { fg = "#161616" })
	hl(0, "TelescopeResultsBorder", { fg = "#161616" })
	hl(0, "TelescopePreviewBorder", { fg = "#161616" })

	hl(0, "FloatBorder", { fg = "#161616" })

	hl(0, "GitSignsAdd", { fg = "#B9CA4A" })
	hl(0, "GitSignsDelete", { fg = "#E78C45" })
	hl(0, "GitSignsChange", { fg = "#7AA6DA" })
	hl(0, "GitSignsUntracked", { fg = "#505050" })
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
