return {
	cmd = { "/opt/homebrew/lib/ruby/gems/3.4.0/bin/ruby-lsp" },
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
