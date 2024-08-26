local api = vim.api
local M = {}

local dressing_config = {
	input = {
		default_prompt = "Input:",
		prompt_align = "center",
		relative = "editor",
		prefer_width = 0.5, -- 50% of editor width
		max_width = nil,
		min_width = 40,
		win_options = {
			winblend = 0,
			winhighlight = "NormalFloat:DiagnosticInfo",
		},
		override = function(conf)
			conf.border = "rounded"
			return conf
		end,
	},
}

-- Setup dressing.nvim
require("dressing").setup(dressing_config)

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
	vim.ui.input({ prompt = "What's up bro?" }, function(question)
		if question then
			if question ~= "" then
				local success, err = pcall(stream_response, question)
				if not success then
					api.nvim_err_writeln("Error: " .. tostring(err))
				end
			else
				api.nvim_err_writeln("No question entered")
			end
		else
			api.nvim_echo({ { "Input cancelled", "WarningMsg" } }, false, {})
		end
	end)
end

api.nvim_set_keymap(
	"n",
	"<leader>x",
	':lua require("hey_bro").prompt_and_send()<CR>',
	{ noremap = true, silent = true }
)

return M
