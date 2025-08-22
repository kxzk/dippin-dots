local function file_path()
	local path_to_file = vim.fn.pathshorten(vim.fn.getcwd()):lower()
	return path_to_file .. "/"
end

local function hl(group, fg, bg)
	vim.cmd("highlight " .. group .. " guifg=" .. fg .. " guibg=" .. bg)
end

hl("StatusColor1", "#aeaeae", "#2d2d2d")
hl("StatusColor", "#4a4a4a", "#2d2d2d")
hl("StatusColor2", "#df69ba", "#2d2d2d")

function status_line()
	-- if vim.bo.filetype == "sql" then
	-- 	return "%f"
	-- end

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
