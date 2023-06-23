local has_mason, mason = pcall(require, "mason")
if not has_mason then
	vim.notify("mason not found!")
	return
end

mason.setup()

local has_mason_lsp_config, mason_lsp_config = pcall(require, "mason-lspconfig")
if not has_mason_lsp_config then
	vim.notify("mason_lsp_config not found!")
end

mason_lsp_config.setup({
	automatic_installation = true,
})

local has_mason_tool_installer, mason_tool_installer = pcall(require, "mason-tool-installer")
if not has_mason_tool_installer then
	vim.notify("mason-tool-installer not found!")
	return
end

mason_tool_installer.setup({
	ensure_installed = {
		-- LSP
		-- handled by mason-lspconfig
		-- FORMATTING
		"stylua",
		"black",
		-- DAP
		"delve",
		"debugpy",
	},
	auto_update = true,
	debounce_hours = 1,
})
