local has_trouble, trouble = pcall(require, "trouble")
if not has_trouble then
	vim.notify("trouble not found!")
	return
end

trouble.setup()
