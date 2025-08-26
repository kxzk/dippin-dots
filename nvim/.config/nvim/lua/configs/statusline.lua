local function file_path()
	local path_to_file = vim.fn.pathshorten(vim.fn.getcwd()):lower()
	return path_to_file .. "/"
end

local function hl(group, fg, bg)
	vim.cmd("highlight " .. group .. " guifg=" .. fg .. " guibg=" .. bg)
end

hl("StatusColor", "#49505f", "#3e4450")
hl("StatusColor1", "#778296", "#3e4450")
hl("StatusColor2", "#df69ba", "#3e4450")

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
