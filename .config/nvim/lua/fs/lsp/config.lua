local servers = {
	"pylsp",
	"gopls",
	"templ",
}

-- Server-specific overrides; blink.cmp adds its completion capabilities to every server
vim.lsp.config("pylsp", {
	settings = {
		pylsp = {
			plugins = {
				jedi_completion = {
					include_params = true,
				},
				pycodestyle = {
					ignore = { "E501" },
				},
			},
		},
	},
})

vim.lsp.enable(servers)
