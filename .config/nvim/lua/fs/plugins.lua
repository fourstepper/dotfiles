local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- Set SQLite library path for sqlite.lua plugin
vim.g.sqlite_clib_path = "/opt/homebrew/opt/sqlite/lib/libsqlite3.dylib"

require("lazy").setup({
	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		ft = { "markdown" },
		build = function()
			vim.fn["mkdp#util#install"]()
		end,
	},
	{
		"saghen/blink.cmp",
		version = "1.*",
		event = "InsertEnter",
		dependencies = {
			"rafamadriz/friendly-snippets",
		},
		opts = {
			keymap = {
				preset = "default",
				["<CR>"] = { "accept", "fallback" },
				["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
				["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
				["<C-u>"] = { "scroll_documentation_up" },
				["<C-d>"] = { "scroll_documentation_down" },
				["<C-e>"] = { "cancel" },
			},
			appearance = {
				nerd_font_variant = "mono",
			},
			completion = {
				ghost_text = { enabled = true },
				documentation = { auto_show = true },
				menu = { auto_show = true },
				list = {
					selection = {
						preselect = true,
						auto_insert = false,
					},
				},
			},
			sources = {
				default = { "lsp", "path", "snippets" },
			},
		},
	},
	"NLKNguyen/papercolor-theme",
	{ "xiyaowong/nvim-colorizer.lua", event = "BufReadPost" },
	"nvim-lualine/lualine.nvim",
	{
		"williamboman/mason.nvim",
		build = ":MasonUpdate",
		dependencies = {
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
		},
	},
	"neovim/nvim-lspconfig",
	"nvim-lua/plenary.nvim",
	{ "nvim-telescope/telescope.nvim", cmd = "Telescope", module = "telescope" },
	{ "nvim-telescope/telescope-fzy-native.nvim", lazy = true },
	{ "nvim-telescope/telescope-smart-history.nvim", lazy = true },
	{
		"otavioschwanck/arrow.nvim",
		opts = {
			show_icons = true,
			leader_key = ";",
		},
	},
	{ "kkharji/sqlite.lua", lazy = true },
	{ "lukas-reineke/indent-blankline.nvim", event = "BufReadPost" },
	"tpope/vim-repeat",
	"tpope/vim-sleuth",
	{ "stevearc/oil.nvim", cmd = "Oil", keys = { { "<leader>f", "<cmd>Oil<CR>", desc = "Open parent directory" } } },
	{ "declancm/maximize.nvim", keys = { { "<leader>m", "<cmd>Maximize<CR>" } } },
	"tpope/vim-surround",
	{
		"tpope/vim-fugitive",
		cmd = { "G", "Git", "GBrowse", "Gvdiffsplit" },
		keys = {
			{ "<leader>gg", "<cmd>G<CR>" },
			{ "<leader>ga", ":G ", desc = "Git command" },
			{ "<leader>gb", "<cmd>GBrowse<CR>" },
			{ "<leader>gb", ":GBrowse<CR>", mode = "v" },
		},
	},
	{ "tpope/vim-rhubarb", lazy = true },
	{ "shumphrey/fugitive-gitlab.vim", lazy = true },
	{ "lewis6991/gitsigns.nvim", event = "BufReadPost" },
	{ "wellle/targets.vim", event = "BufReadPost" },
	{ "windwp/nvim-autopairs", event = "InsertEnter" },
	{ "gaoDean/autolist.nvim", ft = { "markdown", "text" } },
	"christoomey/vim-tmux-navigator",
	{ "arouene/vim-ansible-vault", cmd = { "AnsibleVault", "AnsibleUnvault" } },
	{ "numToStr/Comment.nvim", event = "BufReadPost" },
	{ "tpope/vim-rails", ft = { "ruby", "eruby" } },
	{
		"nvim-treesitter/nvim-treesitter",
		event = "BufReadPost",
		dependencies = {
			"JoosepAlviste/nvim-ts-context-commentstring",
			"vrischmann/tree-sitter-templ",
		},
		build = ":TSUpdate",
	},
	{
		"stevearc/conform.nvim",
		event = "BufWritePre",
		opts = {
			formatters_by_ft = {
				terraform = { "terraform_fmt" },
				json = { "prettierd" },
				hcl = { "terraform_fmt" },
				ruby = { "rubocop" },
				python = { "black" },
				go = { "gofmt" },
				templ = { "templ" },
				svelte = { "prettier" },
				javascript = { "prettierd" },
				typescript = { "prettierd" },
				typescriptreact = { "prettierd" },
				css = { "prettierd" },
				markdown = { "prettierd" },
				lua = { "stylua" },
				html = { "prettierd" },
				["*"] = { "trim_whitespace" },
			},
			format_on_save = {
				timeout_ms = 3000,
				lsp_format = "fallback",
			},
		},
	},
	{
		"mfussenegger/nvim-dap",
		keys = {
			{ "<F5>", function() require("dap").continue() end },
			{ "<leader>b", function() require("dap").toggle_breakpoint() end },
		},
		dependencies = {
			"nvim-telescope/telescope-dap.nvim",
			"leoluz/nvim-dap-go",
			"mfussenegger/nvim-dap-python",
		},
	},
	{
		"rcarriga/nvim-dap-ui",
		keys = { { "<leader>du", function() require("dapui").toggle() end } },
		dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
	},
})
