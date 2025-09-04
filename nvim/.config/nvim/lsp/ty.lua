return {
	cmd = { "ty", "server" },
	filetypes = { "python" },
	settings = {
		ty = {
			diagnosticMode = "workspace",
			inlayHints = {
				variableTypes = true,
				callArgumentNames = true,
			},
		},
	},
}
