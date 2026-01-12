return {
	"ibhagwan/fzf-lua",
	-- optional for icon support
	dependencies = { "nvim-tree/nvim-web-devicons" },
	-- or if using mini.icons/mini.nvim
	-- dependencies = { "echasnovski/mini.icons" },
	config = function(_, opts)
		require("fzf-lua").setup(opts)
		require("fzf-lua").register_ui_select()
	end,
	opts = {
		keymap = {
			fzf = {
				["tab"] = "down",
				["shift-tab"] = "up",
			},
		},
		oldfiles = {
			-- In Telescope, when I used <leader>fr, it would load old buffers.
			-- fzf lua does the same, but by default buffers visited in the current
			-- session are not included. I use <leader>fr all the time to switch
			-- back to buffers I was just in. If you missed this from Telescope,
			-- give it a try.
			include_current_session = true,
		},
		previewers = {
			builtin = {
				-- fzf-lua is very fast, but it really struggled to preview a couple files
				-- in a repo. Those files were very big JavaScript files (1MB, minified, all on a single line).
				-- It turns out it was Treesitter having trouble parsing the files.
				-- With this change, the previewer will not add syntax highlighting to files larger than 100KB
				-- (Yes, I know you shouldn't have 100KB minified files in source control.)
				syntax_limit_b = 1024 * 100, -- 100KB
			},
		},
		grep = {
			-- One thing I missed from Telescope was the ability to live_grep and the
			-- run a filter on the filenames.
			-- Ex: Find all occurrences of "enable" but only in the "plugins" directory.
			-- With this change, I can sort of get the same behaviour in live_grep.
			-- ex: > enable --*/plugins/*
			-- I still find this a bit cumbersome. There's probably a better way of doing this.
			rg_glob = true, -- enable glob parsing
			glob_flag = "--iglob", -- case insensitive globs
			glob_separator = "%s%-%-", -- query separator pattern (lua): ' --'
		},
	},
	keys = {
		{
			"<leader><leader>",
			function()
				require("fzf-lua").files()
			end,
			desc = "Find files",
			nowait = true,
		},
		{
			"<leader>fg",
			function()
				require("fzf-lua").live_grep_native()
			end,
			desc = "Live grep (cwd)",
			nowait = true,
		},
		{
			"<leader>g",
			function()
				require("fzf-lua").grep_curbuf()
			end,
			desc = "Live grep (cwd)",
			nowait = true,
		},
		{
			"<leader>,",
			function()
				require("fzf-lua").buffers()
			end,
			desc = "Buffer search",
			nowait = true,
		},
		{
			"gd",
			function()
				require("fzf-lua").lsp_definitions()
			end,
			desc = "Lsp definitions",
			nowait = true,
		},
		{
			"gr",
			function()
				require("fzf-lua").lsp_references()
			end,
			desc = "Lsp references",
			nowait = true,
		},
		{
			"ca",
			function()
				require("fzf-lua").lsp_code_actions()
			end,
			desc = "fzf code actions",
			nowait = true,
		},
	},
}
