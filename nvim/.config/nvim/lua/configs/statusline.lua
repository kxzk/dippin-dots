local function branch_name()
	local branch = io.popen("git rev-parse --abbrev-ref HEAD 2> /dev/null")
	if branch then
		local name = branch:read("*l")
		branch:close()
		if name then
			return name
		else
			return ""
		end
	end
end

local function file_path()
	local path_to_file = vim.fn.pathshorten(vim.fn.getcwd()):lower()
	return path_to_file .. "/"
end

local function hl(group, fg, bg)
	vim.cmd("highlight " .. group .. " guifg=" .. fg .. " guibg=" .. bg)
end

-- colorscheme: neovim 0.10 default
hl("StatusColor1", "#4f5258", "#1c1d23")
hl("StatusColor", "#2c2e33", "#1c1d23")

function status_line()
	return table.concat({
		"%#StatusColor1#",
		" ",
		"%<",
		branch_name(),
		"%#StatusColor#",
		"%=",
		file_path(),
		"%#StatusColor1#",
		"%f",
		"%#StatusColor#",
		"%=",
		"%m",
		"%y",
		" ",
	})
end

vim.opt.statusline = "%!luaeval('status_line()')"
