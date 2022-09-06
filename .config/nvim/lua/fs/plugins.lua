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
	use("nvim-orgmode/orgmode")
	use("morhetz/gruvbox")
	use("NLKNguyen/papercolor-theme")
	use("nvim-lualine/lualine.nvim")
	use("hrsh7th/cmp-buffer")
	use("hrsh7th/cmp-path")
	use("hrsh7th/cmp-nvim-lsp")
	use("hrsh7th/cmp-nvim-lua")
	use("hrsh7th/nvim-cmp")
	use("L3MON4D3/LuaSnip")
	use("saadparwaiz1/cmp_luasnip")
	use("neovim/nvim-lspconfig")
	use("jose-elias-alvarez/null-ls.nvim")
	use("nvim-lua/plenary.nvim")
	use("nvim-telescope/telescope.nvim")
	use("tami5/sqlite.lua")
	use("nvim-telescope/telescope-fzy-native.nvim")
	use("nvim-telescope/telescope-smart-history.nvim")
	use({
		"nvim-treesitter/nvim-treesitter",
		run = ":TSUpdate",
	})
	use("p00f/nvim-ts-rainbow")
	use("lukas-reineke/indent-blankline.nvim")
	use("mhartington/formatter.nvim")
	use("kyazdani42/nvim-tree.lua")
	use("savq/paq-nvim")
	use("tpope/vim-repeat")
	use("tpope/vim-surround")
	use("tpope/vim-fugitive")
	use("lewis6991/gitsigns.nvim")
	use("wellle/targets.vim")
	use("windwp/nvim-autopairs")
	use("christoomey/vim-tmux-navigator")
	use("arouene/vim-ansible-vault")
	use("numToStr/Comment.nvim")
	use("rafamadriz/friendly-snippets")
	-- debugging
	use("mfussenegger/nvim-dap")
	use("rcarriga/nvim-dap-ui")
	use("nvim-telescope/telescope-dap.nvim")
	use("leoluz/nvim-dap-go")

	-- Automatically set up your configuration after cloning packer.nvim
	-- Put this at the end after all plugins
	if PACKER_BOOTSTRAP then
		require("packer").sync()
	end
end)
