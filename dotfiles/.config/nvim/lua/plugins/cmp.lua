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
		build = "cargo build --release",
		opts_extend = { "sources.default" },
	},
	{
		"L3MON4D3/LuaSnip",
		-- follow latest release.
		-- install jsregexp (optional!).
		build = "make install_jsregexp",
		opts = {},
	},
}
