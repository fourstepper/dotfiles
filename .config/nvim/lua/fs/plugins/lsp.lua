return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		-- Loaded first so its plugin file registers completion capabilities before any server starts
		"saghen/blink.cmp",
	},
	config = function()
		require("fs.lsp")
	end,
}
