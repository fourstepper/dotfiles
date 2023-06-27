-- When leaving the nvim-tree buffer, close tree
vim.cmd([[
autocmd WinLeave NvimTree_* :q
]])

-- Setup nvim-tree
require("nvim-tree").setup({
	git = {
		ignore = false,
	},
	view = {
		mappings = {},
		side = "left",
		number = true,
		relativenumber = true,
		adaptive_size = true,
	},
})
