local capabilities = vim.lsp.protocol.make_client_capabilities()

-- blink.cmp augments capabilities automatically when available
local has_blink, blink = pcall(require, "blink.cmp")
if has_blink then
	capabilities = blink.get_lsp_capabilities(capabilities)
end

capabilities.textDocument.completion.completionItem.snippetSupport = true

local servers = {
	"pylsp",
	"gopls",
	"templ",
	"ansiblels",
	"dockerls",
	"jsonls",
	"html",
	"cssls",
	"tailwindcss",
	"eslint",
	"ts_ls",
	"svelte",
	"bashls",
	"terraformls",
	"lua_ls",
}

for _, server in ipairs(servers) do
	vim.lsp.config(server, { capabilities = capabilities })
end

-- Server-specific overrides
vim.lsp.config("pylsp", {
	capabilities = capabilities,
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

vim.lsp.config("lua_ls", {
	capabilities = capabilities,
	settings = {
		Lua = {
			runtime = { version = "LuaJIT" },
			workspace = {
				checkThirdParty = false,
				library = { vim.env.VIMRUNTIME },
			},
		},
	},
})

vim.lsp.enable(servers)
