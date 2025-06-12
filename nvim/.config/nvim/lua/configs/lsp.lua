vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(env)
		local client = vim.lsp.get_client_by_id(env.data.client_id)
		if client:supports_method("textDocument/completion") then
			vim.lsp.completion.enable(true, client.id, env.buf, { autotrigger = true })
		end
	end,
})
