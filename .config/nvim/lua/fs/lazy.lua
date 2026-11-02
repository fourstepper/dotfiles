local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	-- Every module in lua/fs/plugins/ returns a plugin spec
	spec = { { import = "fs.plugins" } },
	-- No plugin here ships a rockspec, so skip luarocks/hererocks entirely
	rocks = { enabled = false },
})
