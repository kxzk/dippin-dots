local function file_path()
	local path_to_file = vim.fn.pathshorten(vim.fn.getcwd()):lower()
	return path_to_file .. "/"
end

local function hl(group, fg, bg)
	vim.cmd("highlight " .. group .. " guifg=" .. fg .. " guibg=" .. bg)
end

hl("StatusColor", "#b8b2a8", "#ede8e0")
hl("StatusColor1", "#1a1a1a", "#ede8e0")
hl("StatusColor2", "#4682b4", "#ede8e0")

function status_line()
	if vim.bo.filetype == "sql" then
		return "%f"
	end

	return table.concat({
		"%#StatusColor1#",
		" ",
		"%<",
		"%#StatusColor#",
		"%=",
		file_path(),
		"%#StatusColor1#",
		"%f",
		"%#StatusColor2#",
		"%=",
		"%m",
		" ",
	})
end

vim.opt.statusline = "%!luaeval('status_line()')"
