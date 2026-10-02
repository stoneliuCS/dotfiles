-- @salesforce/soql-language-server is on npm but ships no bin - it's a
-- library the salesforcedx-vscode-soql extension runs with node. install.sh
-- installs it globally; resolve its server.js via `npm root -g` (lazily, so
-- the nvm-versioned path isn't hardcoded and startup doesn't pay for it).
local server_js

-- Completion results include __SOBJECTS_PLACEHOLDER-style items that the VS
-- Code client replaces with org metadata (SObjects/fields). Neovim has no
-- such middleware, so drop them rather than show them as literal entries.
local function drop_placeholders(result)
	local items = result and (result.items or result)
	if type(items) ~= "table" then
		return
	end
	for i = #items, 1, -1 do
		if items[i].label:match("^__.*_PLACEHOLDER") then
			table.remove(items, i)
		end
	end
end

return {
	cmd = function(dispatchers)
		if not server_js then
			local root = vim.trim(vim.fn.system({ "npm", "root", "-g" }))
			server_js = root .. "/@salesforce/soql-language-server/lib/server.js"
		end
		return vim.lsp.rpc.start({ "node", server_js, "--stdio" }, dispatchers)
	end,
	filetypes = { "soql" },
	root_markers = { "sfdx-project.json", ".git" },
	on_init = function(client)
		local request = client.request
		client.request = function(self, method, params, handler, bufnr)
			if method == "textDocument/completion" and handler then
				local orig = handler
				handler = function(err, result, ctx, config)
					drop_placeholders(result)
					return orig(err, result, ctx, config)
				end
			end
			return request(self, method, params, handler, bufnr)
		end
	end,
}
