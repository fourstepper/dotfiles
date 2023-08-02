local cmp_status_ok, cmp = pcall(require, "cmp")
if not cmp_status_ok then
	vim.notify("cmp not found!")
	return
end

local snip_status_ok, luasnip = pcall(require, "luasnip")
if not snip_status_ok then
	vim.notify("luasnip not found!")
	return
end

require("luasnip.loaders.from_vscode").lazy_load()

luasnip.filetype_extend("javascript", { "javascriptreact" })

luasnip.filetype_extend("javascript", { "html" })

cmp.setup({
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	mapping = {
		["<C-y>"] = cmp.config.disable,
		["<C-u>"] = cmp.mapping.scroll_docs(-4),
		["<C-d>"] = cmp.mapping.scroll_docs(4),
		["<C-e>"] = cmp.mapping.close(),
		["<CR>"] = cmp.mapping.confirm({ select = true }),
		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif luasnip.expand_or_locally_jumpable() then
				luasnip.expand_or_jump()
			else
				fallback()
			end
		end, { "i", "s" }),
		["<S-Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, { "i", "s" }),
	},
	-- Sorting copied from https://github.com/tjdevries/config_manager/blob/master/xdg_config/nvim/after/plugin/completion.lua#L129
	sorting = {
		comparators = {
			cmp.config.compare.offset,
			cmp.config.compare.exact,
			cmp.config.compare.score,

			-- Mostly taken from https://github.com/lukas-reineke/cmp-under-comparator
			function(entry1, entry2)
				local _, entry1_under = entry1.completion_item.label:find("^_+")
				local _, entry2_under = entry2.completion_item.label:find("^_+")
				entry1_under = entry1_under or 0
				entry2_under = entry2_under or 0
				if entry1_under > entry2_under then
					return false
				elseif entry1_under < entry2_under then
					return true
				end
			end,

			cmp.config.compare.kind,
			cmp.config.compare.sort_text,
			cmp.config.compare.length,
			cmp.config.compare.order,
		},
	},
	formatting = {
		fields = { "abbr", "menu" },
		format = function(entry, vim_item)
			vim_item.menu = ({
				nvim_lsp = "[LSP]",
				luasnip = "[Snippet]",
				tabnine = "[TN]",
				nvim_lua = "[Neovim]",
				buffer = "[Buffer]",
				path = "[Path]",
			})[entry.source.name]
			return vim_item
		end,
	},
	sources = {
		{ name = "luasnip" },
		{ name = "nvim_lsp" },
		{ name = "cmp_tabnine" },
		{ name = "nvim_lua" },
		{ name = "buffer" },
		{ name = "path" },
	},
	view = {
		entries = "native",
	},
	experimental = {
		ghost_text = true,
	},
})
