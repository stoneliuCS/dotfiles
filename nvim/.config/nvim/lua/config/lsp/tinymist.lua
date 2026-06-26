return {
	cmd = { "tinymist" },
	filetypes = { "typst" },
	-- Without a root, tinymist uses the edited file's own directory, so imports
	-- that climb out of it (e.g. `../../lib/web.typ` from a nested post) fail with
	-- "cannot read file outside project root". Pin the root to the nearest
	-- ancestor holding `.typst-root` (the project root, matching `typst --root`),
	-- falling back to the git root for standalone files.
	root_markers = { ".typst-root", ".git" },
}
