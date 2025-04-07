vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(env)
		local client = vim.lsp.get_client_by_id(env.data.client_id)
		if client:supports_method("textDocument/completion") then
			vim.lsp.completion.enable(true, client.id, env.buf, { autotrigger = true })
		end

		if client:supports_method("textDocument/definition") then
			vim.keymap.set("n", "gD", vim.lsp.buf.definition, {
				buffer = env.buf,
				desc = "Go to definition",
			})
		end
	end,
})
