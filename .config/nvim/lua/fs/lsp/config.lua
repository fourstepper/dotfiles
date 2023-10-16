local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

capabilities.textDocument.completion.completionItem.snippetSupport = true

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

require("lspconfig").templ.setup({
	capabilities = capabilities,
})

require("lspconfig").dockerls.setup({
	capabilities = capabilities,
})

require("lspconfig").jsonls.setup({
	capabilities = capabilities,
})

require("lspconfig").html.setup({
	capabilities = capabilities,
})

require("lspconfig").cssls.setup({
	capabilities = capabilities,
})

require("lspconfig").tailwindcss.setup({
	capabilities = capabilities,
})

require("lspconfig").eslint.setup({
	capabilities = capabilities,
})

require("lspconfig").tsserver.setup({
	capabilities = capabilities,
})

require("lspconfig").svelte.setup({
	capabilities = capabilities,
})

require("lspconfig").lua_ls.setup({
	capabilities = capabilities,
	settings = {
		Lua = {
			runtime = {
				-- Tell the language server which version of Lua you're using
				-- (most likely LuaJIT in the case of Neovim)
				version = "LuaJIT",
			},
			diagnostics = {
				-- Get the language server to recognize the `vim` global
				globals = {
					"vim",
					"require",
				},
			},
			workspace = {
				-- Make the server aware of Neovim runtime files
				library = vim.api.nvim_get_runtime_file("", true),
			},
			-- Do not send telemetry data containing a randomized but unique identifier
			telemetry = {
				enable = false,
			},
		},
	},
})
