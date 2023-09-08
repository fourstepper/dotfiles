local globals = {
	vimwiki_list = { { path = "~/workspace/personal/wiki", syntax = "markdown", ext = ".md" } },
	vimwiki_global_ext = 0,
	vimwiki_key_mappins = "{ 'all_maps' : 0,}",
}

for k, v in pairs(globals) do
	vim.g[k] = v
end
