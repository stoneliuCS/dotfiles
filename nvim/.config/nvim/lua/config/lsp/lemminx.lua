-- lemminx isn't on Homebrew - install.sh pulls Red Hat's native build from
-- the vscode-xml GitHub release into ~/.local/share/lemminx.
return {
	cmd = { vim.loop.os_homedir() .. "/.local/share/lemminx/lemminx" },
	filetypes = { "xml", "xsd", "xsl", "xslt", "svg" },
	root_markers = { "sfdx-project.json", ".git" },
	settings = {
		xml = {
			-- Most XML (e.g. Salesforce -meta.xml) references no DTD/XSD, so the
			-- default "No grammar constraints" hint would flag nearly every file.
			validation = { noGrammar = "ignore" },
		},
	},
}
