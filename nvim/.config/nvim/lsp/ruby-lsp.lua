return {
	cmd = { "ruby-lsp" },
	root_markers = { "Gemfile", ".git" },
	filetypes = { "ruby", "eruby" },
	init_options = {
		formatter = "auto",
		linters = { "rubocop" },
		indexing = {
			includedPatterns = { "**/*.rb" },
			excludedPatterns = { "**/tmp/**", "**/vendor/**", "**/node_modules/**" },
		},
	},
}
