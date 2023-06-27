local maximize_status_ok, maximize = pcall(require, "maximize")
if not maximize_status_ok then
	vim.notify("maximize not found!")
	return
end

maximize.setup()
