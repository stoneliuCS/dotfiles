-- Seed once at load; LuaJIT's math.random is otherwise deterministic per session,
-- which makes every fresh nvim emit the same zettel suffix (e.g. always "-USPT").
math.randomseed(vim.uv.hrtime())

return {
	"obsidian-nvim/obsidian.nvim",
	version = "*", -- use latest release, remove to use latest commit
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	---@module 'obsidian'
	---@type obsidian.config
	opts = {
		legacy_commands = false, -- this will be removed in 4.0.0
		-- Ids carry a sortable timestamp *and* a readable slug. obsidian.nvim
		-- derives the filename from the id, so this keeps filename == id while
		-- staying legible in the Obsidian app's file explorer.
		note_id_func = function(title)
			local builtin = require("obsidian.builtin")
			local slug = builtin.title_to_slug(title)
			-- title_to_slug already returns a full zettel id when the title is
			-- missing or unslugifiable; pass it through instead of prefixing a
			-- second timestamp onto it.
			if slug:match("^%d+%-%u%u%u%u$") then
				return slug
			end
			return os.time() .. "-" .. slug
		end,
		workspaces = {
			{
				name = "zk",
				path = "~/stone-zone/wiki/zk",
			},
		},
	},
}
