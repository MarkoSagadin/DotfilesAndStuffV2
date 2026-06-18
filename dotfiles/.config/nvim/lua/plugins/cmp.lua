return {
	{
		"saghen/blink.cmp",
		event = "InsertEnter",
		dependencies = { "rafamadriz/friendly-snippets", { "L3MON4D3/LuaSnip", version = "v2.*" } },
		opts = {
			sources = {
				default = { "snippets", "lsp", "buffer", "path" },
			},
			snippets = { preset = "luasnip" },
		},
		opts_extend = { "sources.default" },
		version = "1.*",
	},
	{
		"L3MON4D3/LuaSnip",
		-- follow latest release.
		-- install jsregexp (optional!).
		build = "make install_jsregexp",
		opts = {},
	},
}
