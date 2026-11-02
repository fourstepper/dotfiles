return {
	"nvim-telescope/telescope.nvim",
	cmd = "Telescope",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{
			"nvim-telescope/telescope-smart-history.nvim",
			dependencies = {
				{
					"kkharji/sqlite.lua",
					init = function()
						vim.g.sqlite_clib_path = "/opt/homebrew/opt/sqlite/lib/libsqlite3.dylib"
					end,
				},
			},
		},
	},
	config = function()
		local actions = require("telescope.actions")
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
						["<C-k>"] = actions.cycle_history_prev,
						["<C-j>"] = actions.cycle_history_next,
						["<A-j>"] = actions.move_selection_next,
						["<A-k>"] = actions.move_selection_previous,
						["<esc>"] = "close",
					},
				},
				file_ignore_patterns = {
					".git/.*",
					".svelte%-kit.*",
					"node_modules",
					".terragrunt-cache.*",
					".terraform",
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
	end,
}
