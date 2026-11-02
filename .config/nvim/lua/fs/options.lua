local globals = {
	mapleader = " ",
	tmux_navigator_no_mappings = "1",
	fugitive_gitlab_domains = { "https://gitlab.skypicker.com" },
}

for k, v in pairs(globals) do
	vim.g[k] = v
end

local options = {
	mouse = "a",
	pumblend = 5,
	clipboard = "unnamedplus",
	linebreak = true,
	termguicolors = true,
	updatetime = 300,
	background = "light",
	number = true,
	relativenumber = true,
	-- Make search better
	hlsearch = false,
	ignorecase = true,
	smartcase = true,
	-- Tab stuff
	expandtab = true,
	shiftwidth = 4,
	softtabstop = 4,
	-- Always see at least 10 lines ahead
	scrolloff = 10,
	-- Provides tab completion for all file related tasks
	path = "**",
	-- Undo history!
	undofile = true,
}

for k, v in pairs(options) do
	vim.opt[k] = v
end
