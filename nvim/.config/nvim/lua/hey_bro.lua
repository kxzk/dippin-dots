local api = vim.api
local fn = vim.fn
local M = {}

local function create_tmux_split_and_run(command)
	local result = os.execute('tmux split-window -h "' .. command .. '; exec fish"')
	if result ~= 0 then
		error("Failed to create tmux split. Is tmux running?")
	end
end

local function stream_response(question)
	local escaped_question = question:gsub('"', '\\"'):gsub("'", "\\'")
	local command = string.format("bro %s", escaped_question)
	create_tmux_split_and_run(command)
end

function M.prompt_and_send()
	local question = fn.input("What's up bro? ")
	if question ~= "" then
		local success, err = pcall(stream_response, question)
		if not success then
			api.nvim_err_writeln("Error: " .. tostring(err))
		end
	else
		api.nvim_err_writeln("No question entered")
	end
end

api.nvim_set_keymap(
	"n",
	"<leader>x",
	':lua require("hey_bro").prompt_and_send()<CR>',
	{ noremap = true, silent = true }
)

return M
