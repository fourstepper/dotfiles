local globals = {
	mapleader = " ",
	tmux_navigator_no_mappings = "1",
}

for k, v in pairs(globals) do
	vim.g[k] = v
end

local options = {
	mouse = "a",
	pumblend = 5,
	-- pumheight = 3,
	clipboard = "unnamedplus",
	linebreak = true,
	termguicolors = true,
	updatetime = 300,
	background = "light",
	number = true,
	relativenumber = true,
	-- Make search better
	hlsearch = false,
	incsearch = true,
	ignorecase = true,
	smartcase = true,
	-- Tab stuff
	tabstop = 8,
	expandtab = true,
	shiftwidth = 4,
	softtabstop = 4,
	modeline = true,
	secure = true,
	-- Always see at least 10 lines ahead
	scrolloff = 10,
	-- Provides tab completion for all file related tasks
	path = "**",
	-- Display all matching files during the auto completion process
	wildmenu = true,
	-- Show leaderkey command
	showcmd = true,
	-- Undo history!
	undofile = true,
	undodir = { vim.fn.stdpath("config") .. "/undo" },
	undolevels = 1000,
	undoreload = 10000,
}

for k, v in pairs(options) do
	vim.opt[k] = v
end
