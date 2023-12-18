local status_ok, treesitter_configs = pcall(require, "nvim-treesitter.configs")
if not status_ok then
	return
end

treesitter_configs.setup({
	ensure_installed = "all",
	auto_install = false,
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false,
	},
})

local has_ts_context, ts_context = pcall(require, "treesitter-context")
if not has_ts_context then
	return
end

ts_context.setup({
	patterns = {
		terraform = {
			"block",
			"object_elem",
			"attribute",
		},
	},
})

local has_ts_commentstring, ts_commentstring = pcall(require, "ts_context_commentstring")
if not has_ts_commentstring then
	return
end

ts_commentstring.setup()
