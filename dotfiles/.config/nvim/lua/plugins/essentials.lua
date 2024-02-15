return {
	"nvim-lua/plenary.nvim",
	{
		"gbprod/substitute.nvim",
		keys = { "<s>", "<ss>" },
		opts = {
			highlight_substituted_text = {
				enabled = false,
			},
		},
	},
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		opts = {},
	},

	{
		"karb94/neoscroll.nvim",
		keys = { "<C-a>", "<C-d>" },
		config = function(_, opts)
			require("neoscroll").setup(opts)

			local t = {}
			t["<C-a>"] = { "scroll", { "-vim.wo.scroll", "true", "350" } }
			t["<C-d>"] = { "scroll", { "vim.wo.scroll", "true", "350" } }
			t["zt"] = { "zt", { "300" } }
			t["zz"] = { "zz", { "300" } }
			t["zb"] = { "zb", { "300" } }

			require("neoscroll.config").set_mappings(t)
		end,
	},
	{
		"aserowy/tmux.nvim",
		keys = { "<C-h>", "<C-j>", "<C-k>", "<C-l>" },
		opts = {
			-- We want to use this plugin only for navigation,
			-- copy_sync feature only messes up the perfectly fine
			-- "copy to clipboard" behavoiur.
			copy_sync = { enable = false },
		},
	},
	{ "iamcco/markdown-preview.nvim", ft = "markdown", build = "cd app && yarn install" },
	{
		"nvim-lualine/lualine.nvim",
		event = "VimEnter",
		config = function(_, _)
			require("ui")
		end,
	},
	{
		"folke/which-key.nvim",
		keys = { "<leader>", "<c-r>", "<c-w>", "\"", "'", "`", "c", "v", "g" },
		cmd = "WhichKey",
		opts = {},
	},
}
