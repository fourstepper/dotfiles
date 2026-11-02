local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
local text, numhl = {}, {}
for type, icon in pairs(signs) do
	local severity = vim.diagnostic.severity[type:upper()]
	text[severity] = icon
	numhl[severity] = "DiagnosticSign" .. type
end

vim.diagnostic.config({
	virtual_text = false,
	signs = { text = text, numhl = numhl },
	underline = true,
})
