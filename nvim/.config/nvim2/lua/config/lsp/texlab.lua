return {
	cmd = { "texlab" },
	filetypes = { "tex" },
	settings = {
		texlab = {
			-- Increase timeout for formatting
			latexFormatter = "latexindent",
			latexindent = {
				["local"] = nil,
				modifyLineBreaks = false,
			},
		},
	},
}
