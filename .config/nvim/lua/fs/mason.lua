local has_mason, mason = pcall(require, "mason")
if not has_mason then
	vim.notify("mason not found!")
	return
end

mason.setup()

local has_mason_lsp_config, mason_lsp_config = pcall(require, "mason-lspconfig")
if not has_mason_lsp_config then
	vim.notify("mason_lsp_config not found!")
	return
end

mason_lsp_config.setup({
	automatic_installation = true,
})
