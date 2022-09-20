local status_ok, treesitter_configs = pcall(require, "nvim-treesitter.configs")
if not status_ok then
	return
end

treesitter_configs.setup({
	highlight = {
		enable = true,
	},
	ensure_installed = "all",
	ignore_install = { "phpdoc" },
	indent = {
		enable = false,
	},
	rainbow = {
		enable = true,
		extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
		max_file_lines = nil, -- Do not enable for files with more than n lines, int
	},
})

local has_ts_context, ts_context = pcall(require, "treesitter-context")
if not has_ts_context then
	return
end

ts_context.setup({
	patterns = {
		terraform = { "block" },
	},
})
