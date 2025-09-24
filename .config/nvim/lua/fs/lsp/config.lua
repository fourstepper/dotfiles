local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

capabilities.textDocument.completion.completionItem.snippetSupport = true

vim.lsp.config('pylsp', {
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
vim.lsp.config('gopls', { capabilities = capabilities })
vim.lsp.config('templ', { capabilities = capabilities })
vim.lsp.config('ansiblels', { capabilities = capabilities })
vim.lsp.config('dockerls', { capabilities = capabilities })
vim.lsp.config('jsonls', { capabilities = capabilities })
vim.lsp.config('html', { capabilities = capabilities })
vim.lsp.config('cssls', { capabilities = capabilities })
vim.lsp.config('tailwindcss', { capabilities = capabilities })
vim.lsp.config('eslint', { capabilities = capabilities })
vim.lsp.config('ts_ls', { capabilities = capabilities })
vim.lsp.config('svelte', { capabilities = capabilities })
vim.lsp.config('bashls', { capabilities = capabilities })
vim.lsp.config('terraformls', { capabilities = capabilities })
