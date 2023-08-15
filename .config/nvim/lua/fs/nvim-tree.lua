require("nvim-tree").setup({
	git = {
		ignore = false,
	},
	view = {
		-- sets relativenumber current cursor to number
		side = "left",
		number = true,
		relativenumber = true,
		adaptive_size = true,
	},
})
