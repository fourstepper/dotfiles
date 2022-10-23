local capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities())

require("lspconfig").bashls.setup({
	capabilities = capabilities,
})
require("lspconfig").terraformls.setup({
	capabilities = capabilities,
})
require("lspconfig").yamlls.setup({
	capabilities = capabilities,
})
require("lspconfig").pylsp.setup({
	capabilities = capabilities,
	settings = {
		pylsp = {
			plugins = {
				jedi_completion = {
					include_params = true,
				},
				pycodestyle = {
					-- ignore max line length
					ignore = { "E501" },
				},
			},
		},
	},
})
require("lspconfig").gopls.setup({
	capabilities = capabilities,
})
require("lspconfig").dockerls.setup({
	capabilities = capabilities,
})
