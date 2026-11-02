local parsers = {
	"go",
	"gomod",
	"gosum",
	"python",
	"templ",
	-- Bundled with Neovim (help, hover docs, render-markdown); installed here so they match nvim-treesitter's queries
	"c",
	"lua",
	"markdown",
	"markdown_inline",
	"query",
	"vim",
	"vimdoc",
}

return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		lazy = false,
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter").install(parsers)

			vim.api.nvim_create_autocmd("FileType", {
				group = vim.api.nvim_create_augroup("TreesitterStart", { clear = true }),
				callback = function(args)
					-- Fails quietly for filetypes without an installed parser
					pcall(vim.treesitter.start, args.buf)
				end,
			})
		end,
	},
	{
		"JoosepAlviste/nvim-ts-context-commentstring",
		lazy = true,
		opts = { enable_autocmd = false },
		init = function()
			-- Native gc commenting: use the commentstring of the language under the cursor
			local get_option = vim.filetype.get_option
			vim.filetype.get_option = function(filetype, option)
				return option == "commentstring"
						and require("ts_context_commentstring.internal").calculate_commentstring()
					or get_option(filetype, option)
			end
		end,
	},
}
