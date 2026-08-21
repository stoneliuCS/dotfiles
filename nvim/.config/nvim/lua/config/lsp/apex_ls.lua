-- apex-jorje-lsp.jar isn't published standalone - it only ships bundled
-- inside the salesforcedx-vscode-apex VS Code extension. install.sh pulls it
-- out of that extension's .vsix into ~/.local/share/apex-language-server.
return {
	cmd = function(dispatchers)
		local jar = vim.loop.os_homedir() .. "/.local/share/apex-language-server/apex-jorje-lsp.jar"
		local cmd = {
			vim.env.JAVA_HOME and (vim.env.JAVA_HOME .. "/bin/java") or "java",
			"-cp",
			jar,
			"-Ddebug.internal.errors=true",
			"-Ddebug.semantic.errors=false",
			"-Ddebug.completion.statistics=false",
			"-Dlwc.typegeneration.disabled=true",
			"apex.jorje.lsp.ApexLanguageServerLauncher",
		}
		return vim.lsp.rpc.start(cmd, dispatchers)
	end,
	filetypes = { "apex" },
	root_markers = { "sfdx-project.json" },
}
