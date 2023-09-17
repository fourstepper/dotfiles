vim.cmd([[filetype plugin indent on]])

vim.cmd([[
augroup FileTypeIndent
autocmd!
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
autocmd FileType terraform setlocal ts=2 sts=2 sw=2 expandtab
autocmd FileType typescript setlocal ts=8 sw=8 noexpandtab
autocmd FileType typescriptreact setlocal ts=2 sts=2 sw=2 noexpandtab
autocmd FileType svelte setlocal ts=2 sw=2 noexpandtab
autocmd FileType markdown setlocal ts=2 sts=2 sw=2 noexpandtab
autocmd FileType css setlocal ts=2 sts=2 sw=2 noexpandtab
autocmd FileType scss setlocal ts=2 sts=2 sw=2 noexpandtab
autocmd FileType lua setlocal ts=8 sw=8 noexpandtab
autocmd FileType go setlocal ts=8 sw=8 noexpandtab
augroup END
]])

-- Disable automatic comment insertion
vim.cmd([[
augroup CommentInsert
autocmd!
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
augroup END
]])
