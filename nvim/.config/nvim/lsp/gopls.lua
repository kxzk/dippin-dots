return {
	cmd = { "gopls" },
	filetypes = { "go", "gomod", "gosum" },
	root_markers = {
		"go.mod",
		"go.sum",
	},
	settings = {
		gopls = {
			analyses = {
				unusedparams = true,
				inferTypeArgs = true,
			},
			hints = {
				parameterNames = true,
			},
			staticcheck = true,
			gofumpt = true,
		},
	},
}
