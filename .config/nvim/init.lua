local cmd = vim.cmd -- to execute Vim commands e.g. cmd('pwd')
local fn = vim.fn -- to call Vim functions e.g. fn.bufnr()
local g = vim.g -- a table to access global variables
local opt = vim.opt -- to set options
local fn = vim.fn

g.mapleader = " "
opt.mouse = "a"
-- set transparency of the pop-up window
opt.pumblend = 5
opt.clipboard = "unnamedplus"

-- Bootstrap Paq when needed
local install_path = fn.stdpath("data") .. "/site/pack/paqs/start/paq-nvim"
if fn.empty(fn.glob(install_path)) > 0 then
	fn.system({ "git", "clone", "--depth=1", "https://github.com/savq/paq-nvim.git", install_path })
end

require("paq")({
        "morhetz/gruvbox",
        "NLKNguyen/papercolor-theme",
	"nvim-lualine/lualine.nvim",
	"hrsh7th/cmp-buffer",
	"hrsh7th/cmp-path",
	"hrsh7th/cmp-nvim-lsp",
	"hrsh7th/cmp-nvim-lua",
	"hrsh7th/nvim-cmp",
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
	"neovim/nvim-lspconfig",
        "nvim-lua/plenary.nvim",
	"nvim-telescope/telescope.nvim",
        "tami5/sqlite.lua",
	"nvim-telescope/telescope-fzy-native.nvim",
	"nvim-telescope/telescope-smart-history.nvim",
	"nvim-treesitter/nvim-treesitter",
        "p00f/nvim-ts-rainbow",
        "lukas-reineke/indent-blankline.nvim",
        "mhartington/formatter.nvim",
        "kyazdani42/nvim-tree.lua",
	"savq/paq-nvim",
	"tpope/vim-repeat",
	"tpope/vim-surround",
        "tpope/vim-fugitive",
        "lewis6991/gitsigns.nvim",
	"wellle/targets.vim",
	"windwp/nvim-autopairs",
        "christoomey/vim-tmux-navigator",
        "arouene/vim-ansible-vault",
        "numToStr/Comment.nvim"
})


-- Plugins config
local tree_cb = require("nvim-tree.config").nvim_tree_callback
require'nvim-tree'.setup {
  view = {
    mappings = {},
    -- sets relativenumber current cursor to number
    number = true,
    relativenumber = true
  }
}

require("nvim-autopairs").setup({
  map_cr = true, --  map <CR> on insert mode
  map_complete = true, -- it will auto insert `(` after select function or method item
  auto_select = false, -- automatically select the first item
})

require('Comment').setup()

require("indent_blankline").setup {
    char = "|",
    buftype_exclude = {"terminal"}
}

require('gitsigns').setup{
  signs = {
    delete = { hl = "GitSignsDelete", text = "契", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
    topdelete = { hl = "GitSignsDelete", text = "契", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
  },
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    map('n', ']c', function()
      if vim.wo.diff then return ']c' end
      vim.schedule(function() gs.next_hunk() end)
      return '<Ignore>'
    end, {expr=true})

    map('n', '[c', function()
      if vim.wo.diff then return '[c' end
      vim.schedule(function() gs.prev_hunk() end)
      return '<Ignore>'
    end, {expr=true})

    -- Actions
    map({'n', 'v'}, '<leader>hs', ':Gitsigns stage_hunk<CR>')
    map({'n', 'v'}, '<leader>hr', ':Gitsigns reset_hunk<CR>')
    map('n', '<leader>hS', gs.stage_buffer)
    map('n', '<leader>hu', gs.undo_stage_hunk)
    map('n', '<leader>hR', gs.reset_buffer)
    map('n', '<leader>hp', gs.preview_hunk)
    map('n', '<leader>hb', function() gs.blame_line{full=true} end)
    map('n', '<leader>tb', gs.toggle_current_line_blame)
    map('n', '<leader>hd', gs.diffthis)
    map('n', '<leader>hD', function() gs.diffthis('~') end)
    map('n', '<leader>td', gs.toggle_deleted)

  end
}

require("formatter").setup({
  filetype = {
    terraform = {
      function()
        return {
          exe = "terraform",
          args = { "fmt"},
          stdin = false
        }
      end
    },
    python = {
      function()
        return {
          exe = "python3 -m autopep8",
          args = {
            "--in-place --aggressive --aggressive",
            vim.fn.fnameescape(vim.api.nvim_buf_get_name(0))
          },
          stdin = false
        }
      end
    },
    hcl = {
      function()
        return {
          exe = "terragrunt",
          args = { "hclfmt"},
          stdin = false
        }
      end
    }
  }
})

-- Call format.nvim on save
cmd([[
augroup Format
    autocmd!
    autocmd BufWritePost *.hcl,*.tf FormatWrite
augroup END
]])

cmd([[
augroup TrimTrailingWhiteSpace
    au!
    au BufWritePre * %s/\s\+$//e
    au BufWritePre * %s/\n\+\%$//e
augroup END
]])

  -- Setup nvim-cmp.
local cmp = require'cmp'

local snip_status_ok, luasnip = pcall(require, "luasnip")
if not snip_status_ok then
  vim.notify("luasnip not found!")
  return
end

local check_backspace = function()
  local col = vim.fn.col "." - 1
  return col == 0 or vim.fn.getline("."):sub(col, col):match "%s"
end

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = {
        ['<C-u>'] = cmp.mapping.scroll_docs(-4),
        ['<C-d>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.close(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.expandable() then
            luasnip.expand()
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          elseif check_backspace() then
            fallback()
          else
            fallback()
          end
        end, {
          "i",
          "s",
        }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, {
          "i",
          "s",
        }),
  },
  formatting = {
    fields = { "abbr", "menu" },
    format = function(entry, vim_item)
      vim_item.menu = ({
        nvim_lsp = "[LSP]",
        luasnip = "[Snippet]",
        buffer = "[Buffer]",
        path = "[Path]",
      })[entry.source.name]
      return vim_item
    end,
  },
  sources = {
    { name = 'nvim_lua' },
    { name = 'nvim_lsp' },
    { name = 'path' },
    { name = 'luasnip' },
    { name = 'buffer' },
  },
  experimental = {
    native_menu = false,
    ghost_text = true,
  },
})

-- Setup lualine
local status, lualine = pcall(require, "lualine")
if (not status) then return end
lualine.setup {
  options = {
    icons_enabled = true,
    theme = 'PaperColor',
    section_separators = {'', ''},
    component_separators = {'', ''},
    disabled_filetypes = {}
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch'},
    lualine_c = { {'filename', path = 1} },
    lualine_d = {'filetype'},

    lualine_x = {
      { 'diagnostics', sources = {"nvim_diagnostic"}, symbols = {error = ' ', warn = ' ', info = ' ', hint = ' '} },
      'encoding',
      'filetype'
    },
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { {'filename', path = 1} },
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
      i = {
	["<C-j>"] = require('telescope.actions').cycle_history_prev,
	["<C-k>"] = require('telescope.actions').cycle_history_next,
        ["<C-c>"] = function()
          vim.cmd [[stopinsert]]
        end,
        ['<esc>'] = 'close',
      },
    },
    file_ignore_patterns = {
        ".git",
        "node_modules",
        ".terragrunt-cache",
        ".cache",
        "__pycache__",
        "undo"

    },
    history = {
      path = '~/.local/share/nvim/telescope_history.sqlite3',
      limit = 100,
    }
  }
}

require('telescope').load_extension('smart_history')

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
require'lspconfig'.pylsp.setup {
    capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities()),
    settings = {
        pylsp = {
            plugins = {
                jedi_completion = {
                    include_params = true,
                },
                pycodestyle = {
                    -- ignore max line length
                    ignore = {'E501'},
                }
            },
        },
    },
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
        spacing = 5,
    },
    signs = true,
    underline = true,
    update_in_insert = false,
})

local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

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

opt.background = 'light'
cmd([[colorscheme PaperColor]])

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
-- Open nvimtree
    map('n', '<leader>n', ':NvimTreeToggle<CR>')
    map('n', '<leader>m', ':NvimTreeFindFileToggle<CR>')
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
    map("n", "<leader>gj", ":diffget //3<CR>")
    map("n", "<leader>gf", ":diffget //2<CR>")
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
    map("n", "<C-h>", "<cmd>lua require('telescope.builtin').command_history()<CR>")
    map("n", "<leader>gs", "<cmd>lua require('telescope.builtin').grep_string()<CR>")
    map("n", "<leader>gc", "<cmd>lua require('telescope.builtin').git_commits()<CR>")
    map("n", "<leader>gb", "<cmd>lua require('telescope.builtin').git_branches()<CR>")
-- Git
    map("n", "<leader>ga", ":Git fetch --all<CR>")
-- LSP mappings
    map('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>')
    map('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>')
    map('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>')
    map('n', 'gsh', '<Cmd>lua vim.lsp.buf.signature_help()<CR>')
    map('n', 'gr', '<Cmd>lua vim.lsp.buf.references()<CR>')
    map('n', 'gca', '<Cmd>lua vim.lsp.buf.code_action()<CR>')
-- Diagnostics
    map('n', '<leader>sd', '<Cmd>lua vim.diagnostic.open_float()<CR>')
