require("telescope").setup({
	defaults = {
		vimgrep_arguments = {
			"rg",
			"--color=never",
			"--no-heading",
			"--with-filename",
			"--line-number",
			"--column",
			"--smart-case",
			"--hidden",
			"-u",
		},
		mappings = {
			i = {
				["<C-j>"] = require("telescope.actions").cycle_history_prev,
				["<C-k>"] = require("telescope.actions").cycle_history_next,
				["<esc>"] = "close",
			},
		},
		file_ignore_patterns = {
			".git/.*",
			"node_modules",
			".terragrunt-cache.*",
			".cache.*",
			"venv",
			"__pycache__",
			"undo",
		},
		history = {
			path = "~/.local/share/nvim/telescope_history.sqlite3",
			limit = 100,
		},
	},
})

require("telescope").load_extension("smart_history")

require("telescope").load_extension("fzf")
