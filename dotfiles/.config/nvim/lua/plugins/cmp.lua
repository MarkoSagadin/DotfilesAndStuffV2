local config = function(_, _)
	local cmp = require("cmp")
	local luasnip = require("luasnip")
	local cmp_buffer = require("cmp_buffer")
	local compare = cmp.config.compare

	require("luasnip/loaders/from_vscode").lazy_load()

	--   פּ ﯟ   some other good icons
	local kind_icons = {
		Namespace = "󰌗",
		Text = "󰉿",
		Method = "󰆧",
		Function = "",
		Constructor = "",
		Field = "󰜢",
		Variable = "󰀫",
		Class = "󰠱",
		Interface = "",
		Module = "",
		Property = "󰜢",
		Unit = "󰑭",
		Value = "󰎠",
		Enum = "",
		Keyword = "󰌋",
		Snippet = "",
		Color = "󰏘",
		File = "󰈚",
		Reference = "󰈇",
		Folder = "󰉋",
		EnumMember = "",
		Constant = "󰏿",
		Struct = "󰙅",
		Event = "",
		Operator = "󰆕",
		TypeParameter = "󰊄",
		Table = "",
		Object = "󰅩",
		Tag = "",
		Array = "[]",
		Boolean = "",
		Number = "",
		Null = "󰟢",
		String = "󰉿",
		Calendar = "",
		Watch = "󰥔",
		Package = "",
		Copilot = "",
		Codeium = "",
		TabNine = "",
	}
	-- find more here: https://www.nerdfonts.com/cheat-sheet

	local function border(hl_name)
		return {
			{ "╭", hl_name },
			{ "─", hl_name },
			{ "╮", hl_name },
			{ "│", hl_name },
			{ "╯", hl_name },
			{ "─", hl_name },
			{ "╰", hl_name },
			{ "│", hl_name },
		}
	end

	local formatting_style = {
		-- default fields order i.e completion word + item.kind + item.kind icons
		fields = { "abbr", "kind", "menu" },

		format = function(_, item)
			local icon = kind_icons[item.kind]
			-- Menu is useless, that's why we set it to nothing.
			item.menu = ""
			-- We combine here both the icon and the kind (LSP for example)
			item.kind = string.format("%s %s", " " .. icon .. " ", item.kind)

			return item
		end,
	}

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
		formatting = formatting_style,
		sorting = {
			priority_weight = 1,
			comparators = {
				-- Sort by distance of the word from the cursor
				-- https://github.com/hrsh7th/cmp-buffer#locality-bonus-comparator-distance-based-sorting
				function(...)
					return cmp_buffer:compare_locality(...)
				end,
				compare.offset,
				compare.exact,
				compare.score,
				compare.recently_used,
				compare.locality,
				compare.kind,
				compare.sort_text,
				compare.length,
				compare.order,
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
			completion = {
				side_padding = 1,
				winhighlight = "Normal:CmpPmenu",
				scrollbar = false,
				border = border("CmpBorder"),
			},
			documentation = {
				border = border("CmpDocBorder"),
				winhighlight = "Normal:CmpDoc",
			},
		},
	})
end

return {
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			{
				-- Snippet plugin
				"L3MON4D3/LuaSnip",
				dependencies = "rafamadriz/friendly-snippets",
				config = function(_, _)
					require("snippets")
				end,
			},
			-- cmp sources plugins
			{
				"hrsh7th/cmp-nvim-lua",
				"hrsh7th/cmp-nvim-lsp",
				"hrsh7th/cmp-buffer",
				"hrsh7th/cmp-path",
				"hrsh7th/cmp-nvim-lsp-signature-help",
				"hrsh7th/cmp-git",
				"saadparwaiz1/cmp_luasnip",
			},
		},
		config = config,
	},
}
