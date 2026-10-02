-- agentscript-lsp is published standalone on npm (unlike apex-jorje-lsp.jar);
-- install.sh installs it globally with `npm install -g @sf-agentscript/lsp-server`.
return {
	cmd = { "agentscript-lsp", "--stdio" },
	filetypes = { "agentscript" },
	root_markers = { "sfdx-project.json", ".git" },
}
