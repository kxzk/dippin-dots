local function branch_name()
	local branch = io.popen('git rev-parse --abbrev-ref HEAD 2> /dev/null')
	if branch then
		local name = branch:read('*l')
		branch:close()
		if name then
			return name
		else
			return ''
		end
	end
end

local function file_path()
	local path_to_file = vim.fn.pathshorten(vim.fn.getcwd()):lower()
    return path_to_file .. '/'
end

local function hl(group, fg, bg)
    vim.cmd('highlight ' .. group .. ' guifg=' .. fg .. ' guibg=' .. bg)
end

hl('StatusColor', '#4C566A', '#3B4252')
hl('StatusColor1', '#81A1C1', '#3B4252')

function status_line()
    return table.concat {
        '%#StatusColor1#',
        ' ', 
        '%<',
        branch_name(),
        '%#StatusColor#',
        '%=',
        file_path(),
        '%#StatusColor1#',
        '%f',
        '%#StatusColor#',
        '%=',
        '%m',
        '%y',
        ' '
    }
end

vim.opt.statusline = "%!luaeval('status_line()')"
