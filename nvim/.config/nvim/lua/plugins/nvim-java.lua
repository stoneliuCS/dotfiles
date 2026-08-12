return {
	"nvim-java/nvim-java",
	ft = { "java" },
	config = function()
		require("java").setup()
		-- disabled while trying out nvim-intellij-lsp for Java
		-- vim.lsp.enable("jdtls")
	end,
}
