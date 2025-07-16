local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

capabilities.textDocument.completion.completionItem.snippetSupport = true

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
require("lspconfig").gopls.setup({ capabilities = capabilities })
require("lspconfig").templ.setup({ capabilities = capabilities })
require("lspconfig").ansiblels.setup({ capabilities = capabilities })
require("lspconfig").dockerls.setup({ capabilities = capabilities })
require("lspconfig").jsonls.setup({ capabilities = capabilities })
require("lspconfig").html.setup({ capabilities = capabilities })
require("lspconfig").cssls.setup({ capabilities = capabilities })
require("lspconfig").tailwindcss.setup({ capabilities = capabilities })
require("lspconfig").eslint.setup({ capabilities = capabilities })
require("lspconfig").ts_ls.setup({ capabilities = capabilities })
require("lspconfig").svelte.setup({ capabilities = capabilities })
require("lspconfig").bashls.setup({ capabilities = capabilities })
require("lspconfig").terraformls.setup({ capabilities = capabilities })
