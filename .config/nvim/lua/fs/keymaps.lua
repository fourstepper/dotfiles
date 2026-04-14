local map = vim.keymap.set

-- Make S-Tab unindent in insert mode
map("i", "<S-Tab>", "<C-d>")
-- Make Y yank to end of the line
map("n", "Y", "y$")
-- Don't lose paste content when replacing something
map("x", "<leader>p", '"_dP')
-- Make new horizontal split and switch over to it
map("n", "<leader>w", "<C-w><C-s><C-w>j")
-- Make new vertical split and switch over to it
map("n", "<leader>v", "<C-w><C-v><C-w>l")
-- Tmux mappings for switching between nvim and tmux seamlessly
map("n", "<M-h>", "<cmd>TmuxNavigateLeft<CR>", { silent = true })
map("n", "<M-j>", "<cmd>TmuxNavigateDown<CR>", { silent = true })
map("n", "<M-k>", "<cmd>TmuxNavigateUp<CR>", { silent = true })
map("n", "<M-l>", "<cmd>TmuxNavigateRight<CR>", { silent = true })
-- Ansible-vault
map("n", "<leader>ave", "<cmd>AnsibleVault<CR>", { silent = true })
map("n", "<leader>avd", "<cmd>AnsibleUnvault<CR>", { silent = true })
-- Git merge resolution
map("n", "<leader>gj", "<cmd>diffget //3<CR>")
map("n", "<leader>gf", "<cmd>diffget //2<CR>")
-- Telescope
map("n", "<C-p>", function() require("telescope.builtin").find_files({ hidden = true, no_ignore = true }) end)
map("n", "<C-g>", function() require("telescope.builtin").live_grep() end)
map("n", "<C-h>", function() require("telescope.builtin").command_history() end)
map("n", "<leader>gc", function() require("telescope.builtin").git_commits() end)
map("n", "<leader>km", function() require("telescope.builtin").keymaps() end)
-- LSP
map("n", "gd", function() require("telescope.builtin").lsp_definitions() end)
map("n", "gr", function() require("telescope.builtin").lsp_references() end)
map("n", "K", function() vim.lsp.buf.hover() end)
-- Diagnostics
map("n", "<leader>xd", function() require("telescope.builtin").diagnostics({ bufnr = 0 }) end)
map("n", "<leader>xw", function() require("telescope.builtin").diagnostics() end)
-- Debugging
map("n", "<F5>", function() require("dap").continue() end)
map("n", "<F10>", function() require("dap").step_over() end)
map("n", "<F11>", function() require("dap").step_into() end)
map("n", "<F12>", function() require("dap").step_out() end)
map("n", "<leader>b", function() require("dap").toggle_breakpoint() end)
map("n", "<leader>B", function() require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: ")) end)
map("n", "<leader>lp", function() require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: ")) end)
map("n", "<leader>dr", function() require("dap").repl.open() end)
map("n", "<leader>dl", function() require("dap").run_last() end)
map("n", "<leader>dq", function() require("dap").terminate() end)
map("n", "<leader>du", function() require("dapui").toggle() end)
-- Oil
map("n", "<leader>f", "<cmd>Oil<CR>", { desc = "Open parent directory" })
