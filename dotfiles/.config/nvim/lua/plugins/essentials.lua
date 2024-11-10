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
			neoscroll = require("neoscroll")
			neoscroll.setup({
				easing = "quadratic",
			})
			local keymap = {
				-- Use the "sine" easing function
				["<C-a>"] = function()
					neoscroll.ctrl_u({ duration = 300 })
				end,
				["<C-d>"] = function()
					neoscroll.ctrl_d({ duration = 300 })
				end,
			}
			local modes = { "n", "v", "x" }
			for key, func in pairs(keymap) do
				vim.keymap.set(modes, key, func)
			end
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
