-- commando.lua - a minimalist cream/beige colorscheme
local M = {}

function M.setup()
	-- Reset highlighting
	vim.cmd("hi clear")
	if vim.fn.exists("syntax_on") then
		vim.cmd("syntax reset")
	end

	vim.g.colors_name = "cream"
	vim.o.background = "light"
	vim.o.termguicolors = true

	-- Color palette
	local colors = {
		bg = "#F5F2ED", -- Warm cream
		bg_alt = "#EDE8E0", -- Slightly darker for UI elements
		fg = "#1A1A1A", -- Near black
		subtle = "#6B7D6A", -- Muted sage green for comments
		line_nr = "#B8B2A8", -- Darker than bg for line numbers
		visual = "#E0D8CC", -- Selection
		cursor_line = "#EDE8E0", -- Current line
		match = "#D4C8B8", -- Search/matching
		error = "#D04545", -- Black
		warning = "#8B7D8B", -- Purple
		info = "#4682B4", -- Muted blue
		hint = "#5F8A5F", -- Muted green
		border = "#D4CFC7", -- UI borders
	}

	-- Helper function
	local function hi(group, opts)
		local cmd = "hi " .. group
		if opts.fg then
			cmd = cmd .. " guifg=" .. opts.fg
		end
		if opts.bg then
			cmd = cmd .. " guibg=" .. opts.bg
		end
		if opts.style then
			cmd = cmd .. " gui=" .. opts.style
		end
		if opts.link then
			vim.cmd("hi! link " .. group .. " " .. opts.link)
			return
		end
		vim.cmd(cmd)
	end

	-- Editor highlights
	hi("Normal", { fg = colors.fg, bg = colors.bg })
	hi("NormalFloat", { fg = colors.fg, bg = colors.bg_alt })
	hi("FloatBorder", { fg = colors.border, bg = colors.bg_alt })
	hi("Cursor", { fg = colors.bg, bg = colors.fg })
	hi("CursorLine", { bg = colors.cursor_line })
	hi("CursorLineNr", { fg = colors.fg, bg = colors.cursor_line, style = "bold" })
	hi("LineNr", { fg = colors.line_nr })
	hi("SignColumn", { fg = colors.line_nr, bg = colors.bg })
	hi("VertSplit", { fg = colors.border })
	hi("StatusLine", { fg = colors.fg, bg = colors.bg_alt })
	hi("StatusLineNC", { fg = colors.subtle, bg = colors.bg_alt })
	hi("Visual", { bg = colors.visual })
	hi("Search", { bg = colors.match })
	hi("IncSearch", { bg = colors.match, style = "bold" })
	hi("MatchParen", { bg = colors.match, style = "bold" })
	hi("NonText", { fg = colors.line_nr })
	hi("EndOfBuffer", { fg = colors.bg })
	hi("Folded", { fg = colors.subtle, bg = colors.bg_alt })
	hi("FoldColumn", { fg = colors.subtle, bg = colors.bg })
	hi("Pmenu", { fg = colors.fg, bg = colors.bg_alt })
	hi("PmenuSel", { fg = colors.fg, bg = colors.visual, style = "bold" })
	hi("PmenuSbar", { bg = colors.bg_alt })
	hi("PmenuThumb", { bg = colors.border })
	hi("TabLine", { fg = colors.subtle, bg = colors.bg_alt })
	hi("TabLineFill", { bg = colors.bg_alt })
	hi("TabLineSel", { fg = colors.fg, bg = colors.bg, style = "bold" })

	-- Syntax highlights
	hi("Comment", { fg = colors.subtle, style = "italic" })
	hi("Constant", { fg = colors.fg })
	hi("String", { fg = colors.fg })
	hi("Character", { fg = colors.fg })
	hi("Number", { fg = colors.fg })
	hi("Boolean", { fg = colors.fg })
	hi("Float", { fg = colors.fg })
	hi("Identifier", { fg = colors.fg })
	hi("Function", { fg = colors.fg, style = "bold" })
	hi("Statement", { fg = colors.fg, style = "bold" })
	hi("Conditional", { fg = colors.fg, style = "bold" })
	hi("Repeat", { fg = colors.fg, style = "bold" })
	hi("Label", { fg = colors.fg })
	hi("Operator", { fg = colors.fg })
	hi("Keyword", { fg = colors.fg, style = "bold" })
	hi("Exception", { fg = colors.fg, style = "bold" })
	hi("PreProc", { fg = colors.fg })
	hi("Include", { fg = colors.fg })
	hi("Define", { fg = colors.fg })
	hi("Macro", { fg = colors.fg })
	hi("PreCondit", { fg = colors.fg })
	hi("Type", { fg = colors.fg, style = "bold" })
	hi("StorageClass", { fg = colors.fg, style = "bold" })
	hi("Structure", { fg = colors.fg, style = "bold" })
	hi("Typedef", { fg = colors.fg, style = "bold" })
	hi("Special", { fg = colors.fg })
	hi("SpecialChar", { fg = colors.fg })
	hi("Tag", { fg = colors.fg })
	hi("Delimiter", { fg = colors.fg })
	hi("SpecialComment", { fg = colors.subtle, style = "italic" })
	hi("Debug", { fg = colors.fg })
	hi("Underlined", { fg = colors.fg, style = "underline" })
	hi("Error", { fg = colors.error })
	hi("Todo", { fg = colors.fg, bg = colors.bg_alt, style = "bold" })

	-- Treesitter highlights
	hi("@variable", { fg = colors.fg })
	hi("@variable.builtin", { fg = colors.fg, style = "italic" })
	hi("@variable.parameter", { fg = colors.fg })
	hi("@variable.member", { fg = colors.fg })
	hi("@constant", { fg = colors.fg })
	hi("@constant.builtin", { fg = colors.fg })
	hi("@constant.macro", { fg = colors.fg })
	hi("@module", { fg = colors.fg })
	hi("@label", { fg = colors.fg })
	hi("@string", { fg = colors.fg })
	hi("@string.documentation", { fg = colors.subtle, style = "italic" })
	hi("@string.regexp", { fg = colors.fg })
	hi("@string.escape", { fg = colors.fg, style = "bold" })
	hi("@string.special", { fg = colors.fg })
	hi("@string.special.symbol", { fg = colors.fg })
	hi("@string.special.url", { fg = colors.fg, style = "underline" })
	hi("@character", { fg = colors.fg })
	hi("@character.special", { fg = colors.fg })
	hi("@boolean", { fg = colors.fg })
	hi("@number", { fg = colors.fg })
	hi("@number.float", { fg = colors.fg })
	hi("@type", { fg = colors.fg, style = "bold" })
	hi("@type.builtin", { fg = colors.fg, style = "bold" })
	hi("@type.qualifier", { fg = colors.fg })
	hi("@type.definition", { fg = colors.fg, style = "bold" })
	hi("@attribute", { fg = colors.fg })
	hi("@property", { fg = colors.fg })
	hi("@function", { fg = colors.fg, style = "bold" })
	hi("@function.builtin", { fg = colors.fg, style = "bold" })
	hi("@function.call", { fg = colors.fg })
	hi("@function.macro", { fg = colors.fg, style = "bold" })
	hi("@function.method", { fg = colors.fg, style = "bold" })
	hi("@function.method.call", { fg = colors.fg })
	hi("@constructor", { fg = colors.fg, style = "bold" })
	hi("@operator", { fg = colors.fg })
	hi("@keyword", { fg = colors.fg, style = "bold" })
	hi("@keyword.function", { fg = colors.fg, style = "bold" })
	hi("@keyword.operator", { fg = colors.fg, style = "bold" })
	hi("@keyword.import", { fg = colors.fg, style = "bold" })
	hi("@keyword.storage", { fg = colors.fg, style = "bold" })
	hi("@keyword.repeat", { fg = colors.fg, style = "bold" })
	hi("@keyword.return", { fg = colors.fg, style = "bold" })
	hi("@keyword.exception", { fg = colors.fg, style = "bold" })
	hi("@keyword.conditional", { fg = colors.fg, style = "bold" })
	hi("@conditional", { fg = colors.fg, style = "bold" })
	hi("@repeat", { fg = colors.fg, style = "bold" })
	hi("@exception", { fg = colors.fg, style = "bold" })
	hi("@include", { fg = colors.fg, style = "bold" })
	hi("@punctuation", { fg = colors.fg })
	hi("@punctuation.delimiter", { fg = colors.fg })
	hi("@punctuation.bracket", { fg = colors.fg })
	hi("@punctuation.special", { fg = colors.fg })
	hi("@comment", { fg = colors.subtle, style = "italic" })
	hi("@comment.documentation", { fg = colors.subtle, style = "italic" })
	hi("@comment.error", { fg = colors.error, style = "italic" })
	hi("@comment.warning", { fg = colors.warning, style = "italic" })
	hi("@comment.todo", { fg = colors.fg, bg = colors.bg_alt, style = "bold,italic" })
	hi("@comment.note", { fg = colors.info, style = "italic" })
	hi("@markup.strong", { style = "bold" })
	hi("@markup.emphasis", { style = "italic" })
	hi("@markup.underline", { style = "underline" })
	hi("@markup.strike", { style = "strikethrough" })
	hi("@markup.heading", { fg = colors.fg, style = "bold" })
	hi("@markup.link", { fg = colors.fg, style = "underline" })
	hi("@markup.link.url", { fg = colors.fg, style = "underline" })
	hi("@markup.list", { fg = colors.fg })
	hi("@diff.plus", { fg = colors.hint })
	hi("@diff.minus", { fg = colors.error })
	hi("@diff.delta", { fg = colors.warning })
	hi("@tag", { fg = colors.fg })
	hi("@tag.attribute", { fg = colors.fg })
	hi("@tag.delimiter", { fg = colors.fg })

	-- LSP highlights
	hi("DiagnosticError", { fg = colors.error })
	hi("DiagnosticWarn", { fg = colors.warning })
	hi("DiagnosticInfo", { fg = colors.info })
	hi("DiagnosticHint", { fg = colors.hint })
	hi("DiagnosticUnderlineError", { style = "undercurl", fg = colors.error })
	hi("DiagnosticUnderlineWarn", { style = "undercurl", fg = colors.warning })
	hi("DiagnosticUnderlineInfo", { style = "undercurl", fg = colors.info })
	hi("DiagnosticUnderlineHint", { style = "undercurl", fg = colors.hint })
	hi("LspReferenceText", { bg = colors.visual })
	hi("LspReferenceRead", { bg = colors.visual })
	hi("LspReferenceWrite", { bg = colors.visual, style = "bold" })

	-- Git highlights
	hi("GitSignsAdd", { fg = colors.hint })
	hi("GitSignsChange", { fg = colors.warning })
	hi("GitSignsDelete", { fg = colors.error })
	hi("DiffAdd", { bg = colors.bg_alt, fg = colors.hint })
	hi("DiffChange", { bg = colors.bg_alt, fg = colors.warning })
	hi("DiffDelete", { bg = colors.bg_alt, fg = colors.error })
	hi("DiffText", { bg = colors.visual, style = "bold" })

	-- Telescope
	hi("TelescopeNormal", { fg = colors.fg, bg = colors.bg })
	hi("TelescopeBorder", { fg = colors.border })
	hi("TelescopePromptBorder", { fg = colors.border })
	hi("TelescopeResultsBorder", { fg = colors.border })
	hi("TelescopePreviewBorder", { fg = colors.border })
	hi("TelescopeSelection", { bg = colors.visual })
	hi("TelescopeSelectionCaret", { fg = colors.fg, bg = colors.visual })
	hi("TelescopeMatching", { fg = colors.fg, style = "bold" })

	-- NvimTree
	hi("NvimTreeNormal", { fg = colors.fg, bg = colors.bg })
	hi("NvimTreeFolderIcon", { fg = colors.subtle })
	hi("NvimTreeFolderName", { fg = colors.fg })
	hi("NvimTreeOpenedFolderName", { fg = colors.fg, style = "bold" })
	hi("NvimTreeEmptyFolderName", { fg = colors.subtle })
	hi("NvimTreeFileDirty", { fg = colors.warning })
	hi("NvimTreeGitDirty", { fg = colors.warning })
	hi("NvimTreeGitStaged", { fg = colors.hint })
	hi("NvimTreeGitDeleted", { fg = colors.error })
	hi("NvimTreeSpecialFile", { fg = colors.fg, style = "bold" })
	hi("NvimTreeIndentMarker", { fg = colors.line_nr })
	hi("NvimTreeCursorLine", { bg = colors.cursor_line })
end

return M
