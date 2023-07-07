local tree_cb = require("nvim-tree.config").nvim_tree_callback
require("nvim-tree").setup({
	git = {
		ignore = false,
	},
	view = {
		mappings = {},
		-- sets relativenumber current cursor to number
		side = "left",
		number = true,
		relativenumber = true,
		adaptive_size = true,
	},
})
