vim.cmd([[filetype plugin indent on]])

-- Disable automatic comment insertion
vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("CommentInsert", { clear = true }),
	pattern = "*",
	callback = function()
		vim.opt_local.formatoptions:remove({ "c", "r", "o" })
	end,
})
