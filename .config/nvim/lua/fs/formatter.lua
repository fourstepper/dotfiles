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
		python = {
			require("formatter.filetypes.python").black,
		},
		go = {
			require("formatter.filetypes.go").gofmt,
		},
		svelte = {
			require("formatter.filetypes.typescriptreact").prettier,
		},
		typescript = {
			require("formatter.filetypes.typescript").prettierd,
		},
		typescriptreact = {
			require("formatter.filetypes.typescriptreact").prettierd,
		},
		css = {
			require("formatter.filetypes.typescriptreact").prettierd,
		},
		scss = {
			require("formatter.filetypes.typescriptreact").prettierd,
		},
		markdown = {
			require("formatter.filetypes.markdown").prettierd,
		},
		lua = {
			require("formatter.filetypes.lua").stylua,
		},
		-- yaml = {
		-- 	require("formatter.filetypes.yaml").prettierd,
		-- },
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
