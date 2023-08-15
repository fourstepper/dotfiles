local has_colorizer, colorizer = pcall(require, "colorizer")
if not has_colorizer then
	vim.notify("colorizer not installed")
	return
end

colorizer.setup(nil, { mode = "virtualtext" })
