local has_neogit, neogit = pcall(require, "neogit")
if not has_neogit then
	return
end

local has_diffview, diffview = pcall(require, "diffview")
if not has_diffview then
	return
end

neogit.setup({
	integrations = {
		diffview = true,
	},
})
