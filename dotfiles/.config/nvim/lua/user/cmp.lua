local cmp_status_ok, cmp = pcall(require, "cmp")
if not cmp_status_ok then
	return
end

local snip_status_ok, luasnip = pcall(require, "luasnip")
if not snip_status_ok then
	return
end

local buffer_status_ok, cmp_buffer = pcall(require, "cmp_buffer")
if not buffer_status_ok then
	return
end

require("luasnip/loaders/from_vscode").lazy_load()

--   פּ ﯟ   some other good icons
local kind_icons = {
	Text = "",
	Method = "m",
	Function = "",
	Constructor = "",
	Field = "",
	Variable = "",
	Class = "",
	Interface = "",
	Module = "",
	Property = "",
	Unit = "",
	Value = "",
	Enum = "",
	Keyword = "",
	Snippet = "",
	Color = "",
	File = "",
	Reference = "",
	Folder = "",
	EnumMember = "",
	Constant = "",
	Struct = "",
	Event = "",
	Operator = "",
	TypeParameter = "",
}
-- find more here: https://www.nerdfonts.com/cheat-sheet

local trim = function(s)
	return (s:gsub("^%s*(.-)%s*$", "%1"))
end

cmp.setup({
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body) -- For `luasnip` users.
		end,
	},
	mapping = {
		-- Select next item in completion menu with ctrl + n
		["<C-n>"] = cmp.mapping.select_next_item(),
		-- Select prev item in completion menu with ctrl + p
		["<C-p>"] = cmp.mapping.select_prev_item(),

		-- Move forward in snippets with ctrl + k
		["<C-j>"] = cmp.mapping(function(fallback)
			if luasnip.expand_or_locally_jumpable() then
				luasnip.expand_or_jump()
			else
				fallback()
			end
		end, { "i", "s" }),
		-- Move backward in snippets with ctrl + k
		["<C-k>"] = cmp.mapping(function(fallback)
			if luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, { "i", "s" }),

		-- Accept currently selected item. If none selected, `select` first
		-- item.
		["<CR>"] = cmp.mapping.confirm({ select = true }),

		["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-1), { "i", "c" }),
		["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(1), { "i", "c" }),
		["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
		["<C-y>"] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
		["<C-e>"] = cmp.mapping({
			i = cmp.mapping.abort(),
			c = cmp.mapping.close(),
		}),
	},
	formatting = {
		fields = { "kind", "abbr", "menu" },
		format = function(entry, vim_item)
			-- Kind icons
			vim_item.kind = string.format("%s", kind_icons[vim_item.kind])
			vim_item.abbr = trim(vim_item.abbr)
			-- vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind) -- This concatonates the icons with the name of the item kind
			vim_item.menu = ({
				nvim_lsp = "[LSP]",
				luasnip = "[Snippet]",
				buffer = "[Buffer]",
				nvim_lua = "[Lua]",
				path = "[Path]",
			})[entry.source.name]

			return vim_item
		end,
	},
	sorting = {
		comparators = {
			function(...)
				return cmp_buffer:compare_locality(...)
			end,
		},
	},
	sources = {
		-- group indxes key solves the issue with the duplicated entries
		{ name = "luasnip", group_index = 1 },
		{ name = "nvim_lsp", group_index = 1 },
		{ name = "nvim_lua", group_index = 1 },
		{ name = "path", group_index = 1 },
		{ name = "buffer", group_index = 2 },
	},
	confirm_opts = {
		behavior = cmp.ConfirmBehavior.Replace,
		select = true,
	},
	window = {
		documentation = cmp.config.window.bordered({ "╭", "─", "╮", "│", "╯", "─", "╰", "│" }),
		completion = cmp.config.window.bordered({ "╭", "─", "╮", "│", "╯", "─", "╰", "│" }),
	},
	experimental = {
		ghost_text = false,
		native_menu = false,
	},
})

-- `/` cmdline setup.
cmp.setup.cmdline("/", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = "buffer" },
	},
})

-- `:` cmdline setup.
cmp.setup.cmdline(":", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{ name = "path" },
	}, {
		{ name = "cmdline" },
	}),
})
