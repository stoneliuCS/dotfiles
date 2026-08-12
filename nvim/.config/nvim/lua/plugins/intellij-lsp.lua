-- The server returns Javadoc as raw HTML (and unexpanded {@code}/{@link}
-- javadoc tags) inside hover content; Neovim's hover handler doesn't parse
-- either, so it renders them literally. This strips the doc-comment `*`
-- gutter and rewrites the common Javadoc/HTML markup to plain markdown
-- before handing off to the default renderer.
--
-- Hover `contents` per the LSP spec is one of: a string, a MarkupContent
-- ({kind, value}), a MarkedString ({language, value}), or an array of any
-- of those - so the transform below recurses into whichever shape shows up.
-- In practice this server puts everything in a single MarkupContent whose
-- `value` already concatenates multiple pre-fenced blocks (e.g. the raw
-- javadoc comment, then the class signature), fenced with 4 backticks - not
-- an LSP array. Each fenced block needs its own doc-vs-code judgment, so the
-- value has to be split on its own fences (whatever length they are) before
-- any conversion happens; treating the whole blob as one unit is what
-- corrupted the signature's `Comparable<String>` last time.
local function strip_javadoc_comment(text)
	text = text:gsub("^%s*/%*%*", ""):gsub("%*/%s*$", "")
	local lines = {}
	for raw_line in (text .. "\n"):gmatch("(.-)\n") do
		table.insert(lines, (raw_line:gsub("^%s*%* ?", "")))
	end
	return table.concat(lines, "\n")
end

--- Splits `text` into an ordered list of `{kind="text", text=...}` and
--- `{kind="code", lang=..., text=...}` segments on fenced code blocks,
--- matching whatever backtick-run length the opening fence used (3, 4, ...)
--- rather than assuming 3.
local function split_fenced_segments(text)
	local segments = {}
	local pos = 1
	local n = #text
	while pos <= n do
		local open_s, open_e, ticks, lang = text:find("(`+)([%w_]*)[ \t]*\r?\n", pos)
		if not open_s then
			table.insert(segments, { kind = "text", text = text:sub(pos) })
			break
		end
		if open_s > pos then
			table.insert(segments, { kind = "text", text = text:sub(pos, open_s - 1) })
		end
		local close_s, close_e = text:find(ticks, open_e + 1, true)
		if not close_s then
			table.insert(segments, { kind = "text", text = text:sub(open_s) })
			break
		end
		table.insert(segments, { kind = "code", lang = lang, text = text:sub(open_e + 1, close_s - 1) })
		pos = close_e + 1
		if text:sub(pos, pos) == "\n" then
			pos = pos + 1
		end
	end
	return segments
end

-- Named narrowly so Java generics like `Comparable<String>` in a real
-- signature don't get misread as an HTML tag and stripped.
local HTML_TAGS = {
	"p", "pre", "code", "a", "b", "i", "em", "strong", "span",
	"blockquote", "li", "ul", "ol", "br", "hr", "div", "u",
	"table", "tr", "td", "h1", "h2", "h3", "h4", "h5", "h6",
}

local function has_html_tag(text)
	for _, tag in ipairs(HTML_TAGS) do
		if text:find("</?" .. tag .. "[%s/>]") then
			return true
		end
	end
	return false
end

local function looks_like_doc(text)
	return has_html_tag(text) or text:find("{@%a") ~= nil or text:find("\n%s*@%a") ~= nil or text:find("^%s*@%a") ~= nil
end

-- Bare newlines between adjacent `@tag` lines (@author, @see, @since, ...)
-- collapse under HTML's whitespace rules, since nothing marks them as
-- separate block elements. Force a line break before each so pandoc keeps
-- them on their own lines.
local function protect_block_tags(html)
	html = html:gsub("\n%s*@(%a+)", "\n<br>@%1")
	html = html:gsub("^%s*@(%a+)", "<br>@%1")
	return html
end

-- JDK Javadoc wraps code samples as `<blockquote><pre>...` with no `<code>`,
-- which pandoc renders as a quoted plain-text blockquote instead of a code
-- block. Unwrap the blockquote and add the `<code>` pandoc needs to recognize
-- it as a code block.
local function force_code_blocks(html)
	html = html:gsub("<pre>", "<pre><code>"):gsub("</pre>", "</code></pre>")
	html = html:gsub("<blockquote>%s*(<pre>)", "%1"):gsub("(</pre>)%s*</blockquote>", "%1")
	return html
end

--- Shells out to pandoc for the actual HTML parsing - regex can't reliably
--- tell a real tag from incidental "<...>" text (e.g. `Comparable<String>`),
--- and pandoc already handles nesting/malformed markup correctly. Falls back
--- to the untouched input if pandoc isn't available or errors.
local function pandoc_html_to_gfm(html)
	local ok, result = pcall(function()
		return vim.system({ "pandoc", "-f", "html", "-t", "gfm", "--wrap=none" }, { stdin = html, text = true }):wait()
	end)
	if not ok or not result or result.code ~= 0 or not result.stdout then
		return html
	end
	return result.stdout
end

-- pandoc's gfm writer emits 4-space indented code blocks rather than fenced
-- ones (gfm has no flag to force fencing), which loses java syntax
-- highlighting in the hover window. Re-fence them ourselves.
local function indented_to_fenced(text)
	local lines = vim.split(text, "\n", { plain = true })
	local out = {}
	local i = 1
	while i <= #lines do
		local line = lines[i]
		if line:match("^    ") then
			table.insert(out, "```java")
			while i <= #lines and (lines[i]:match("^    ") or lines[i] == "") do
				table.insert(out, (lines[i]:gsub("^    ", "")))
				i = i + 1
			end
			while #out > 0 and out[#out] == "" do
				table.remove(out)
			end
			table.insert(out, "```")
		else
			table.insert(out, line)
			i = i + 1
		end
	end
	return table.concat(out, "\n")
end

-- Javadoc's own inline/block tag syntax ({@code}, {@link}, @author, ...) is
-- not HTML, so pandoc passes it through as literal text. Convert it on
-- pandoc's markdown output, where our added `` ` `` / `**` are unambiguous.
local function convert_javadoc_tags(text)
	text = text:gsub("\\\n", "\n") -- pandoc renders our <br> hints as trailing "\"
	text = text:gsub("{@code%s+(.-)}", "`%1`")
	text = text:gsub("{@literal%s+(.-)}", "%1")
	text = text:gsub("{@value%s+(.-)}", "`%1`")
	text = text:gsub("{@link%a*%s+([^%s{}]+)%s*([^{}]-)}", function(ref, label)
		return "`" .. ((label ~= "" and label) or ref) .. "`"
	end)
	text = text:gsub("\n(%s*)@(%a+)", "\n%1**@%2**")
	text = text:gsub("^(%s*)@(%a+)", "%1**@%2**")
	return text
end

local function html_to_markdown(html)
	html = strip_javadoc_comment(html)
	html = protect_block_tags(html)
	html = force_code_blocks(html)
	local md = pandoc_html_to_gfm(html)
	md = indented_to_fenced(md)
	md = convert_javadoc_tags(md)
	return md
end

--- Converts one hover `value` string: splits on any pre-existing fences,
--- converts fenced/unfenced pieces that look like javadoc/HTML, and leaves
--- pieces that look like real source (e.g. containing generics like
--- `Comparable<String>`) completely untouched, re-fencing them with a plain
--- 3-backtick fence so they still render as code.
local function process_value(value)
	local segments = split_fenced_segments(value)
	if #segments == 1 and segments[1].kind == "text" then
		if not looks_like_doc(value) then
			return value
		end
		return html_to_markdown(value)
	end
	local out = {}
	for _, seg in ipairs(segments) do
		if seg.kind == "text" then
			table.insert(out, seg.text)
		elseif looks_like_doc(seg.text) then
			table.insert(out, html_to_markdown(seg.text))
		else
			local code = seg.text:gsub("^\n+", ""):gsub("\n+$", "")
			table.insert(out, "```" .. (seg.lang or "") .. "\n" .. code .. "\n```")
		end
	end
	return table.concat(out)
end

--- Recurses through the hover `contents` shapes and runs each string value
--- through process_value().
local function transform_contents(contents)
	if type(contents) == "string" then
		return process_value(contents)
	end
	if type(contents) ~= "table" then
		return contents
	end
	if contents.value then
		contents.value = process_value(contents.value)
		return contents
	end
	local out = {}
	for i, item in ipairs(contents) do
		out[i] = transform_contents(item)
	end
	return out
end

return {
	"gipo355/nvim-intellij-lsp",
	ft = { "java", "kotlin" },
	opts = {
		server_dir = "~/.local/share/intellij-server",
		inlay_hints = false,
	},
	config = function(_, opts)
		require("intellij-lsp").setup(opts)

		-- Neovim's builtin vim.lsp.buf.hover() (0.10+) always supplies its own
		-- handler to client:request(), so it never consults client.handlers /
		-- vim.lsp.handlers - overriding those (the old, documented extension
		-- point) silently does nothing. Patching client:request() itself is the
		-- only interception point every caller funnels through.
		vim.api.nvim_create_autocmd("LspAttach", {
			callback = function(args)
				local client = vim.lsp.get_client_by_id(args.data.client_id)
				if not client or client.name ~= "intellij" or client._html_hover_patched then
					return
				end
				client._html_hover_patched = true

				local orig_request = client.request
				client.request = function(self, method, params, handler, bufnr)
					if method == "textDocument/hover" and handler then
						local orig_handler = handler
						handler = function(err, result, ctx, cfg)
							local function finish()
								if result and result.contents then
									result.contents = transform_contents(result.contents)
								end
								orig_handler(err, result, ctx, cfg)
							end
							-- transform_contents() may shell out to pandoc and block
							-- on it; that's unsafe straight out of the RPC callback,
							-- which can run in a fast event context.
							if vim.in_fast_event() then
								vim.schedule(finish)
							else
								finish()
							end
						end
					end
					return orig_request(self, method, params, handler, bufnr)
				end
			end,
		})
	end,
}
