return {
	cmd = { "zls" },
	filetypes = { "zig", "zir" },
	root_markers = {
		"build.zig",
		"build.zig.zon",
	},
	settings = {
		zls = {
			enable_build_on_save = true,
			semantic_tokens = "full",
			warn_style = true,
			skip_std_references = true,
			inlay_hints_show_variable_type_hints = true,
			inlay_hints_show_parameter_name = true,
			inlay_hints_hide_redundant_param_names = true,
			inlay_hints_hide_redundant_param_names_last_token = true,
		},
	},
}
