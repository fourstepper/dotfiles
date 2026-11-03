local function maximize_status()
	return vim.t.maximized and "   " or ""
end

return {
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {
			options = {
				globalstatus = true,
				icons_enabled = true,
				theme = "PaperColor",
				section_separators = { "", "" },
				component_separators = { "", "" },
				disabled_filetypes = {},
			},
			sections = {
				lualine_a = { "mode" },
				lualine_b = { "branch", maximize_status },
				lualine_c = { { "filename", path = 1 } },
				lualine_x = {
					{
						"diagnostics",
						sources = { "nvim_diagnostic" },
						symbols = { error = " ", warn = " ", info = " ", hint = " " },
					},
					"encoding",
					"filetype",
				},
				lualine_y = { "progress" },
				lualine_z = { "location" },
			},
			inactive_sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = { { "filename", path = 1 } },
				lualine_x = { "location" },
				lualine_y = {},
				lualine_z = {},
			},
			tabline = {},
			extensions = { "fugitive" },
		},
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		event = { "BufReadPost", "BufNewFile" },
		opts = {
			indent = {
				char = "|",
			},
			scope = {
				enabled = false,
			},
			exclude = {
				filetypes = {
					"fugitive",
				},
			},
		},
	},
	{
		"catgoose/nvim-colorizer.lua",
		event = { "BufReadPost", "BufNewFile" },
		opts = {
			options = {
				display = { mode = "virtualtext" },
			},
		},
	},
}
