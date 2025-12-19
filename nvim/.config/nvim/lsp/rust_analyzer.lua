return {
	cmd = { "rust-analyzer" },
	filetypes = { "rust" },
	root_markers = {
		"Cargo.toml",
		"Cargo.lock",
	},
	settings = {
		["rust-analyzer"] = {
			checkOnSave = { command = "clippy" },
			cargo = { allFeatures = false },
			procMacro = { enable = true },
			diagnostics = { disabled = { "unresolved-proc-macro" } },
		},
	},
}
