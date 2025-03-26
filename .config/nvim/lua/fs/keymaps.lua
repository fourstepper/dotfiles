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

-- Make S-Tab unindent in normal mode
keymap("i", "<S-Tab>", "<C-d>")
-- Make Y yank to end of the line
keymap("n", "Y", "y$")
-- Don't lose paste content when replacing something
keymap("x", "<leader>p", '"_dP')
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
-- Harpoon
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
keymap("n", "<leader>gc", "<cmd>lua require('telescope.builtin').git_commits()<CR>")
keymap("n", "<leader>gb", "<cmd>lua require('telescope.builtin').git_branches()<CR>")
keymap("n", "<leader>km", "<cmd>lua require('telescope.builtin').keymaps()<CR>")
-- Git
keymap("n", "<leader>gg", ":G<CR>")
keymap("n", "<leader>ga", ":G ")
-- LSP mappings
keymap("n", "gd", "<Cmd>lua vim.lsp.buf.definition()<CR>")
keymap("n", "gr", "<Cmd>lua vim.lsp.buf.references()<CR>")
keymap("n", "K", "<Cmd>lua vim.lsp.buf.hover()<CR>")
-- Trouble
keymap("n", "gi", "<cmd>Trouble lsp toggle focus=true<CR>")
keymap("n", "<leader>xd", "<cmd>Trouble diagnostics toggle filter.buf=0 focus=true<cr>")
keymap("n", "<leader>xw", "<cmd>Trouble diagnostics toggle focus=true<cr>")
-- Debugging
keymap("n", "<F5>", "<Cmd>lua require'dap'.continue()<CR>")
keymap("n", "<F10>", "<Cmd>lua require'dap'.step_over()<CR>")
keymap("n", "<F11>", "<Cmd>lua require'dap'.step_into()<CR>")
keymap("n", "<F12>", "<Cmd>lua require'dap'.step_out()<CR>")
keymap("n", "<leader>b", "<Cmd>lua require'dap'.toggle_breakpoint()<CR>")
keymap("n", "<leader>B", "<Cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>")
keymap("n", "<leader>lp", "<Cmd>lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>")
keymap("n", "<leader>dr", "<Cmd>lua require'dap'.repl.open()<CR>")
keymap("n", "<leader>dl", "<Cmd>lua require'dap'.run_last()<CR>")
keymap("n", "<leader>dq", "<Cmd>lua require'dap'.terminate()<CR>")
keymap("n", "<leader>du", "<Cmd> lua require'dapui'.toggle()<CR>")
-- oil.nvim like vim-vinegar
keymap("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
-- avante.nvim
keymap("n", "<leader>ac", ":AvanteClear<CR>", { silent = true })
