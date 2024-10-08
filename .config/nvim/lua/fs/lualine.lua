local status, lualine = pcall(require, "lualine")
if not status then
	return
end

local function maximize_status()
	return vim.t.maximized and "   " or ""
end

lualine.setup({
	options = {
		globalstatus = true,
		icons_enabled = true,
		section_separators = { "", "" },
		component_separators = { "", "" },
		disabled_filetypes = {},
	},
	sections = {
		lualine_a = { "mode" },
		lualine_b = { "branch", maximize_status },
		lualine_c = { { "filename", path = 1 } },
		lualine_d = { "filetype" },

		lualine_x = {
			{
				"diagnostics",
				sources = { "nvim_diagnostic" },
				symbols = { error = " ", warn = " ", info = " ", hint = " " },
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
})
