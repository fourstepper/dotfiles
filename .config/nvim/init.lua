local cmd = vim.cmd -- to execute Vim commands e.g. cmd('pwd')
local fn = vim.fn -- to call Vim functions e.g. fn.bufnr()
local g = vim.g -- a table to access global variables
local opt = vim.opt -- to set options
local fn = vim.fn

g.mapleader = " "

-- Bootstrap Paq when needed
local install_path = fn.stdpath("data") .. "/site/pack/paqs/start/paq-nvim"
if fn.empty(fn.glob(install_path)) > 0 then
	fn.system({ "git", "clone", "--depth=1", "https://github.com/savq/paq-nvim.git", install_path })
end

require("paq")({
        "morhetz/gruvbox",
	"nvim-lualine/lualine.nvim",
	"hrsh7th/cmp-buffer",
	"hrsh7th/cmp-path",
	"hrsh7th/cmp-nvim-lsp",
	"hrsh7th/cmp-nvim-lua",
	"hrsh7th/cmp-vsnip",
	"hrsh7th/nvim-cmp",
	"hrsh7th/vim-vsnip",
	"neovim/nvim-lspconfig",
        "nvim-lua/plenary.nvim",
	"nvim-telescope/telescope-fzy-native.nvim",
	"nvim-telescope/telescope.nvim",
	"nvim-treesitter/nvim-treesitter",
        "p00f/nvim-ts-rainbow",
        "lukas-reineke/indent-blankline.nvim",
	"savq/paq-nvim",
	"tpope/vim-repeat",
	"tpope/vim-surround",
        "tpope/vim-fugitive",
        "tpope/vim-commentary",
        "airblade/vim-gitgutter",
	"wellle/targets.vim",
	"windwp/nvim-autopairs",
        "christoomey/vim-tmux-navigator",
        "arouene/vim-ansible-vault"
})


-- Plugins config
require("nvim-autopairs").setup({})
require("nvim-autopairs.completion.cmp").setup({
  map_cr = true, --  map <CR> on insert mode
  map_complete = true, -- it will auto insert `(` after select function or method item
  auto_select = false, -- automatically select the first item
})

require("indent_blankline").setup {
    char = "|",
    buftype_exclude = {"terminal"}
}

  -- Setup nvim-cmp.
local cmp = require'cmp'

cmp.setup({
  snippet = {
    expand = function(args)
      -- For `vsnip` user.
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = {
        ['<C-p>'] = cmp.mapping.select_prev_item(),
        ['<C-n>'] = cmp.mapping.select_next_item(),
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.close(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
  },
  sources = {
    { name = 'nvim_lua' },
    { name = 'nvim_lsp' },
    { name = 'path' }

    -- For vsnip user.
    { name = 'vsnip' },
    { name = 'buffer' },
  }
})

-- Setup lualine
local status, lualine = pcall(require, "lualine")
if (not status) then return end
lualine.setup {
  options = {
    icons_enabled = true,
    theme = 'gruvbox',
    section_separators = {'', ''},
    component_separators = {'', ''},
    disabled_filetypes = {}
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch'},
    lualine_c = {'filename'},
    lualine_x = {
      { 'diagnostics', sources = {"nvim_lsp"}, symbols = {error = ' ', warn = ' ', info = ' ', hint = ' '} },
      'encoding',
      'filetype'
    },
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  extensions = {'fugitive'}
}

require('telescope').setup{
  defaults = {
    vimgrep_arguments = {
        "rg",
        "--color=never",
        "--no-heading",
        "--with-filename",
        "--line-number",
        "--column",
        "--smart-case",
        "--hidden",
        "-u"
    },
    mappings = {
      n = {
        ["q"] = require('telescope.actions').close
      },
    },
    file_ignore_patterns = {
        ".git",
        "node_modules",
        ".terragrunt-cache",
        ".cache"
    }
  }
}
require('telescope').load_extension('fzy_native')

local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
require'lspconfig'.bashls.setup{
    capabilities = capabilities
}
require'lspconfig'.terraformls.setup{
    capabilities = capabilities
}
require'lspconfig'.tflint.setup{
    capabilities = capabilities
}
require'lspconfig'.yamlls.setup{
    capabilities = capabilities
}
require'lspconfig'.jedi_language_server.setup{
    capabilities = capabilities
}
require'lspconfig'.gopls.setup{
    capabilities = capabilities
}
require'lspconfig'.dockerls.setup{
    capabilities = capabilities
}

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = {
        prefix = "●",
        spacing = 0,
    },
    signs = true,
    underline = true,

    update_in_insert = false,
})

require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  ensure_installed = {
    "python",
    "hcl",
    "go",
    "toml",
    "json",
    "yaml",
    "lua",
  },
  indent = {
    enable = false
  },
  rainbow = {
    enable = true,
    extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
    max_file_lines = nil, -- Do not enable for files with more than n lines, int
    -- colors = {}, -- table of hex strings
    -- termcolors = {} -- table of colour name strings
  }
}

-- Set proper color in Vim
opt.termguicolors = true

-- Set update time to 300ms
opt.updatetime = 300

opt.background = 'dark'
cmd([[colorscheme gruvbox]])

-- Set no highlight after search ends
opt.hlsearch = false

-- turn hybrid line numbers on
opt.number = true
opt.relativenumber = true

-- Check for eight line lines
opt.colorcolumn = '120'

-- Search
opt.incsearch = true
opt.ignorecase = true
opt.smartcase = true

-- Tab stuff
opt.tabstop = 8
opt.expandtab = true
opt.shiftwidth = 4
opt.softtabstop = 4
opt.modeline = true
opt.secure = true

-- Always see at least 15 lines ahead
opt.scrolloff = 15

cmd([[filetype plugin indent on]])

cmd([[
augroup FileTypeIndent
autocmd!
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
autocmd FileType terraform setlocal ts=2 sts=2 sw=2 expandtab
autocmd FileType typescript setlocal ts=8 sw=8 noexpandtab
augroup END
]])

-- Disable automatic comment insertion
cmd([[
augroup CommentInsert
autocmd!
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
augroup END
]])

-- Provides tab completion for all file related tasks
opt.path = '**'

-- Display all matching files during the auto completion process
opt.wildmenu = true

-- Show leaderkey command
opt.showcmd = true

-- Undo history!
opt.undofile = true
opt.undodir = vim.fn.stdpath("config") .. "/undo"
opt.undolevels = 1000
opt.undoreload = 10000

-- Netrw settings
g.netrw_localcopydircmd = 'cp -r'
g.netrw_winsize = 30
g.netrw_banner = 0

cmd([[
function! NetrwMapping()
endfunction

augroup netrw_mapping
  autocmd!
  autocmd filetype netrw call NetrwMapping()
augroup END

function! NetrwMapping()
  nmap <buffer> . gh
  nmap <buffer> H u
  nmap <buffer> h -^
  nmap <buffer> l <CR>:Lexplore<CR>
  nmap <buffer> L <CR>:Lexplore<CR>
  nmap <buffer> <Leader>dd :Lexplore<CR>
endfunction
]])

-- Remove trailing whitespaces
cmd([[
augroup RemoveTrailing
autocmd!
autocmd BufWritePre * :%s/\s\+$//e
augroup END
]])

-- KEYBINDINGS
local function map(mode, lhs, rhs, opts)
  local options = { noremap = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- Make Y yank to end of the line
    map("n", "Y", "y$")
-- Open netrw in the dir of the current file
    map("n", "<leader>dd", ":Lexplore %:p:h<CR>", { silent = true })
-- Open netrw in the current workdir
    map("n", "<leader>da", ":Lexplore <CR>", { silent = true })
-- Make new horizontal split and switch over to it
    map("n", "<leader>w", "<C-w><C-s><C-w>j")
-- Make new vertical split and switch over to it
    map("n", "<leader>v", "<C-w><C-v><C-w>l")
-- Navigate Vim buffers easier
    map("n", "<M-j>", "<C-W><C-J>", { silent = true })
    map("n", "<M-k>", "<C-W><C-K>", { silent = true })
    map("n", "<M-l>", "<C-W><C-L>", { silent = true })
    map("n", "<M-h>", "<C-W><C-H>", { silent = true })
-- Ansible-vault-inline to ,v
    map("n", "<leader>ave", ":AnsibleVault <CR>", { silent = true })
    map("n", "<leader>avd", ":AnsibleUnvault <CR>", { silent = true })
-- Git merge resolution
    map("n", "<leader>gj", ":diffgett //3")
    map("n", "<leader>gf", ":diffgett //2")
-- Tmux mappings for switching between nvim and tmux seamlessly
    g.tmux_navigator_no_mappings = '1'
    map("n", "<M-h>", ":TmuxNavigateLeft<CR>", { silent = true })
    map("n", "<M-j>", ":TmuxNavigateDown<CR>", { silent = true })
    map("n", "<M-k>", ":TmuxNavigateUp<CR>", { silent = true })
    map("n", "<M-l>", ":TmuxNavigateRight<CR>", { silent = true })
    map("n", "<M-\\>", ":TmuxNavigatePrevious<CR>", { silent = true })
-- telescope
    map("n", "<C-p>", "<cmd>lua require('telescope.builtin').find_files{ hidden=true, no_ignore=true }<CR>")
    map("n", "<C-g>", "<cmd>lua require('telescope.builtin').live_grep()<CR>")
-- LSP mappings
    map('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>')
    map('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>')
    map('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>')
    map('n', 'gsh', '<Cmd>lua vim.lsp.buf.signature_help()<CR>')
    map('n', 'gr', '<Cmd>lua vim.lsp.buf.references()<CR>')
    map('n', 'gca', '<Cmd>lua vim.lsp.buf.code_action()<CR>')
