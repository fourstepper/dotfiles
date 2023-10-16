-- Automatically install packer
local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
	PACKER_BOOTSTRAP = vim.fn.system({
		"git",
		"clone",
		"--depth",
		"1",
		"https://github.com/wbthomason/packer.nvim",
		install_path,
	})
	print("Installing packer close and reopen Neovim...")
	vim.cmd([[packadd packer.nvim]])
end

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
	return
end

-- Have packer use a popup window
packer.init({
	display = {
		open_fn = function()
			return require("packer.util").float({ border = "rounded" })
		end,
	},
})

-- Install your plugins here
return packer.startup(function(use)
	use({
		"iamcco/markdown-preview.nvim",
		run = function()
			vim.fn["mkdp#util#install"]()
		end,
	})
	use("NLKNguyen/papercolor-theme")
	use("xiyaowong/nvim-colorizer.lua")
	use("nvim-lualine/lualine.nvim")
	use("hrsh7th/cmp-buffer")
	use("hrsh7th/cmp-path")
	use("hrsh7th/cmp-nvim-lsp")
	use("hrsh7th/cmp-nvim-lua")
	use("hrsh7th/nvim-cmp")
	use("L3MON4D3/LuaSnip")
	use("rafamadriz/friendly-snippets")
	use({
		"williamboman/mason.nvim",
		run = ":MasonUpdate", -- :MasonUpdate updates registry contents
	})
	use("williamboman/mason-lspconfig.nvim")
	use("WhoIsSethDaniel/mason-tool-installer.nvim")
	use("neovim/nvim-lspconfig")
	use("nvim-lua/plenary.nvim")
	use("nvim-telescope/telescope.nvim")
	use("nvim-telescope/telescope-fzy-native.nvim")
	use("nvim-telescope/telescope-smart-history.nvim")
	use("ThePrimeagen/harpoon")
	use("tami5/sqlite.lua")
	use({
		"nvim-treesitter/nvim-treesitter",
		commit = "08aabb145f93ed1dd607ce8e2dcd52d356822300", -- works
		-- commit = "823e67a1c9452075ec7f01e7aa05ac6e7b41fb1e", -- doesn't work
		requires = {
			"JoosepAlviste/nvim-ts-context-commentstring",
			"p00f/nvim-ts-rainbow",
			"vrischmann/tree-sitter-templ",
		},
		run = ":TSUpdate",
	})
	use({
		"nvim-treesitter/nvim-treesitter-context",
		requires = "nvim-treesitter/nvim-treesitter",
	})
	use("lukas-reineke/indent-blankline.nvim")
	use("mhartington/formatter.nvim")
	use({
		"laytan/tailwind-sorter.nvim",
		requires = { "nvim-treesitter/nvim-treesitter", "nvim-lua/plenary.nvim" },
		config = function()
			require("tailwind-sorter").setup({
				on_save_enabled = true,
				on_save_pattern = { "*.html", "*.js", "*.jsx", "*.tsx", "*.svelte" },
			})
		end,
		run = "cd formatter && npm i && npm run build",
	})
	use({
		"nvim-tree/nvim-tree.lua",
		requires = {
			"nvim-tree/nvim-web-devicons",
		},
	})
	use({
		"folke/trouble.nvim",
		requires = {
			"nvim-tree/nvim-web-devicons",
		},
	})
	use("tpope/vim-repeat")
	use("declancm/maximize.nvim")
	use("tpope/vim-surround")
	use("tpope/vim-fugitive")
	use("lewis6991/gitsigns.nvim")
	use("wellle/targets.vim")
	use("windwp/nvim-autopairs")
	use("gaoDean/autolist.nvim")
	use("christoomey/vim-tmux-navigator")
	use("arouene/vim-ansible-vault")
	use("numToStr/Comment.nvim")
	-- debugging
	use("mfussenegger/nvim-dap")
	use({ "rcarriga/nvim-dap-ui", requires = { "mfussenegger/nvim-dap" } })
	use("nvim-telescope/telescope-dap.nvim")
	use("leoluz/nvim-dap-go")
	use("mfussenegger/nvim-dap-python")

	-- Automatically set up your configuration after cloning packer.nvim
	-- Put this at the end after all plugins
	if PACKER_BOOTSTRAP then
		require("packer").sync()
	end
end)
