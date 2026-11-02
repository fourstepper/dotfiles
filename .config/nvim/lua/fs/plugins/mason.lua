-- Not lazy: mason puts its bin dir on PATH for LSP, conform and dap
return {
	{
		"mason-org/mason.nvim",
		lazy = false,
		build = ":MasonUpdate",
		opts = {},
	},
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		lazy = false,
		dependencies = { "mason-org/mason.nvim" },
		opts = {
			ensure_installed = {
				-- LSP
				"gopls",
				"python-lsp-server",
				"templ",
				-- FORMATTING
				"black",
				-- DAP
				"delve",
				"debugpy",
			},
			auto_update = true,
			-- Check for updates at most every 3 days
			debounce_hours = 72,
		},
	},
}
