local function keymap(mode, lhs, rhs, opts)
	local options = { noremap = true }
	if opts then
		options = vim.tbl_extend("force", options, opts)
	end
	vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- Make Y yank to end of the line
keymap("n", "Y", "y$")
-- Open nvimtree
keymap("n", "<leader>n", ":NvimTreeToggle<CR>")
keymap("n", "<leader>m", ":NvimTreeFindFileToggle<CR>")
-- Make new horizontal split and switch over to it
keymap("n", "<leader>w", "<C-w><C-s><C-w>j")
-- Make new vertical split and switch over to it
keymap("n", "<leader>v", "<C-w><C-v><C-w>l")
-- Navigate Vim buffers easier
keymap("n", "<M-j>", "<C-W><C-J>", { silent = true })
keymap("n", "<M-k>", "<C-W><C-K>", { silent = true })
keymap("n", "<M-l>", "<C-W><C-L>", { silent = true })
keymap("n", "<M-h>", "<C-W><C-H>", { silent = true })
-- Ansible-vault-inline to ,v
keymap("n", "<leader>ave", ":AnsibleVault <CR>", { silent = true })
keymap("n", "<leader>avd", ":AnsibleUnvault <CR>", { silent = true })
-- Git merge resolution
keymap("n", "<leader>gj", ":diffget //3<CR>")
keymap("n", "<leader>gf", ":diffget //2<CR>")
-- Tmux mappings for switching between nvim and tmux seamlessly
keymap("n", "<M-h>", ":TmuxNavigateLeft<CR>", { silent = true })
keymap("n", "<M-j>", ":TmuxNavigateDown<CR>", { silent = true })
keymap("n", "<M-k>", ":TmuxNavigateUp<CR>", { silent = true })
keymap("n", "<M-l>", ":TmuxNavigateRight<CR>", { silent = true })
-- telescope
keymap("n", "<C-p>", "<cmd>lua require('telescope.builtin').find_files{ hidden=true, no_ignore=true }<CR>")
keymap("n", "<C-g>", "<cmd>lua require('telescope.builtin').live_grep()<CR>")
keymap("n", "<C-h>", "<cmd>lua require('telescope.builtin').command_history()<CR>")
keymap("n", "<leader>gs", "<cmd>lua require('telescope.builtin').grep_string()<CR>")
keymap("n", "<leader>gc", "<cmd>lua require('telescope.builtin').git_commits()<CR>")
keymap("n", "<leader>gb", "<cmd>lua require('telescope.builtin').git_branches()<CR>")
-- Git
keymap("n", "<leader>ga", ":G ")
keymap("n", "<leader>gg", ":G<CR>")
-- LSP mappings
keymap("n", "K", "<Cmd>lua vim.lsp.buf.hover()<CR>")
keymap("n", "gd", "<Cmd>lua vim.lsp.buf.definition()<CR>")
keymap("n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>")
keymap("n", "gsh", "<Cmd>lua vim.lsp.buf.signature_help()<CR>")
keymap("n", "gr", "<Cmd>lua vim.lsp.buf.references()<CR>")
keymap("n", "gca", "<Cmd>lua vim.lsp.buf.code_action()<CR>")
-- Diagnostics
keymap("n", "<leader>sd", "<Cmd>lua vim.diagnostic.open_float()<CR>")
