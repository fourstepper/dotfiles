local has_oil, oil = pcall(require, "oil")
if not has_oil then
	vim.notify("oil not found!")
	return
end

oil.setup()
