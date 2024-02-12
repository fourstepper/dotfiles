require("formatter").setup({
	filetype = {
		terraform = {
			function()
				return {
					exe = "terraform",
					args = { "fmt", "-" },
					stdin = true,
				}
			end,
		},
		json = {
			require("formatter.filetypes.json").prettierd,
		},
		hcl = {
			function()
				return {
					exe = "terraform",
					args = { "fmt", "-" },
					stdin = true,
				}
			end,
		},
		ruby = {
			require("formatter.filetypes.ruby").rubocop,
		},
		eruby = {
			require("formatter.filetypes.eruby").htmlbeautifier,
		},
		python = {
			require("formatter.filetypes.python").black,
		},
		go = {
			require("formatter.filetypes.go").gofmt,
		},
		templ = {
			function()
				return {
					exe = "templ",
					args = { "fmt" },
					stdin = true,
				}
			end,
		},
		svelte = {
			require("formatter.filetypes.svelte").prettier,
		},
		typescript = {
			require("formatter.filetypes.typescript").prettierd,
		},
		typescriptreact = {
			require("formatter.filetypes.typescriptreact").prettierd,
		},
		css = {
			require("formatter.filetypes.css").prettierd,
		},
		markdown = {
			require("formatter.filetypes.markdown").prettierd,
		},
		lua = {
			require("formatter.filetypes.lua").stylua,
		},
		html = {
			require("formatter.filetypes.html").prettierd,
		},
		["*"] = {
			require("formatter.filetypes.any").remove_trailing_whitespace,
		},
	},
})

-- Call formatter on each save
vim.cmd([[
augroup Format
    autocmd!
    autocmd BufWritePost * FormatWrite
augroup END
]])
