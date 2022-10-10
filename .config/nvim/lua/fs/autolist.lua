local have_autolist, autolist = pcall(require, "autolist")
if not have_autolist then
	return
end

autolist.setup({})
