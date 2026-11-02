return {
	-- Not lazy: oil replaces netrw when nvim opens a directory
	{ "stevearc/oil.nvim", lazy = false, opts = {} },
	{
		"otavioschwanck/arrow.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {
			show_icons = true,
			leader_key = ";",
		},
	},
	{
		"stevearc/conform.nvim",
		event = "BufWritePre",
		opts = {
			formatters_by_ft = {
				python = { "black" },
				go = { "gofmt" },
				templ = { "templ" },
				["*"] = { "trim_whitespace" },
			},
			format_on_save = {
				timeout_ms = 3000,
				lsp_format = "fallback",
			},
		},
	},
	{ "windwp/nvim-autopairs", event = "InsertEnter", opts = {} },
	"tpope/vim-repeat",
	"tpope/vim-sleuth",
	"tpope/vim-surround",
	{ "wellle/targets.vim", event = "BufReadPost" },
	"christoomey/vim-tmux-navigator",
}
