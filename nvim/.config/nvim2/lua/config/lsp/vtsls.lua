return {
	cmd = { "vtsls", "--stdio" },
	filetypes = {
		"javascript",
		"javascriptreact",
		"typescript",
		"typescriptreact",
		"vue",
	},
	settings = {
		vtsls = {
			-- Enable server-side fuzzy matching to reduce client-side work
			experimental = {
				completion = {
					enableServerSideFuzzyMatch = true,
					entriesLimit = 100, -- Limit completion entries (default is unlimited)
				},
			},
		},
		typescript = {
			preferences = {
				-- Disable auto-imports from package.json (reduces noise)
				includePackageJsonAutoImports = "off",

				-- Exclude specific patterns from auto-imports
				autoImportFileExcludePatterns = {
					"node_modules/*",
					".next/*",
					"dist/*",
					"build/*",
				},
			},
			-- Additional performance tweaks
			suggest = {
				enabled = true,
				autoImports = true,
				completeFunctionCalls = false, -- Disable if causes lag
			},
			inlayHints = {
				includeInlayParameterNameHints = "literals",
				includeInlayFunctionParameterTypeHints = false,
				includeInlayVariableTypeHints = false,
				includeInlayPropertyDeclarationTypeHints = false,
			},
		},
		javascript = {
			preferences = {
				includePackageJsonAutoImports = "off",
				autoImportFileExcludePatterns = {
					"node_modules/*",
					"dist/*",
					"build/*",
				},
			},
			suggest = {
				enabled = true,
				autoImports = true,
				completeFunctionCalls = false,
			},
		},
	},
}
