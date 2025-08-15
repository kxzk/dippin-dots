local function file_path()
	local path_to_file = vim.fn.pathshorten(vim.fn.getcwd()):lower()
	return path_to_file .. "/"
end

local function hl(group, fg, bg)
	vim.cmd("highlight " .. group .. " guifg=" .. fg .. " guibg=" .. bg)
end

hl("StatusColor", "#aeaeae", "#c2c2c2")
hl("StatusColor1", "#686868", "#c2c2c2")
hl("StatusColor2", "#df69ba", "#c2c2c2")

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
