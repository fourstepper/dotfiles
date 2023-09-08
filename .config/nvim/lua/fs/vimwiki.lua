local globals = {
	vimwiki_list = { { path = "~/workspace/personal/wiki", syntax = "markdown", ext = ".md" } },
	-- don't register all .md files as vimwiki files (only register the above (vimwiki_list))
	vimwiki_global_ext = 0,
	-- disable global mappings
	vimwiki_key_mappings = { global = 0 },
}

for k, v in pairs(globals) do
	vim.g[k] = v
end
