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

hl("StatusColor", "#32374b", "#2a2e3f")
hl("StatusColor1", "#3a4058", "#2a2e3f")
hl("StatusColor2", "#ffd76d", "#2a2e3f")
hl("StatusModified", "#f9e2af", "#2a2e3f")

local function modified_indicator()
	if vim.bo.modified then
		return "●"
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
