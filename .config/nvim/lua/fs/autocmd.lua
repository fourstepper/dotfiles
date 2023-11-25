vim.cmd([[filetype plugin indent on]])

-- Disable automatic comment insertion
vim.cmd([[
augroup CommentInsert
autocmd!
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
augroup END
]])
