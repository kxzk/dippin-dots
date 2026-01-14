local cached_cwd = ""

local function update_cwd_cache()
	cached_cwd = vim.fn.pathshorten(vim.fn.getcwd()):lower() .. "/"
end

update_cwd_cache()

vim.api.nvim_create_autocmd("DirChanged", {
	callback = update_cwd_cache,
})

local function hl(group, fg, bg)
	vim.cmd("highlight " .. group .. " guifg=" .. fg .. " guibg=" .. bg)
end

local sl_bg = "#2a2e3f"

hl("StatusColor", "#32374b", sl_bg)
hl("StatusColor1", "#4d5368", sl_bg)
hl("StatusColor2", "#ffffff", sl_bg)

local function modified_indicator()
	if vim.bo.modified then
		return "✱"
	end
	return ""
end

function status_line()
	return table.concat({
		"%#StatusColor1#",
		" ",
		"%<",
		"%#StatusColor#",
		"%=",
		cached_cwd,
		"%#StatusColor1#",
		"%f",
		"%#StatusColor2#",
		"%=",
		modified_indicator(),
		" ",
	})
end

vim.opt.statusline = "%!v:lua.status_line()"
