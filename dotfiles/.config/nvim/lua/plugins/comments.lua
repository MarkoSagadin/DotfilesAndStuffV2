return {
	{
		"numToStr/Comment.nvim",
		keys = {
			{ "<leader>ll", mode = "n", desc = "Comment toggle current line" },
			{ "<leader>l", mode = { "n", "o" }, desc = "Comment toggle linewise" },
			{ "<leader>l", mode = "x", desc = "Comment toggle linewise (visual)" },
			{ "<leader>bl", mode = "n", desc = "Comment toggle current block" },
			{ "<leader>b", mode = { "n", "o" }, desc = "Comment toggle blockwise" },
			{ "<leader>b", mode = "x", desc = "Comment toggle blockwise (visual)" },
		},
		opts = {
			toggler = {
				line = "<leader>ll",
				block = "<leader>bl",
			},
			opleader = {
				line = "<leader>l",
				block = "<leader>b",
			},
		},
	},
	{
		"folke/todo-comments.nvim",
		event = "VeryLazy",
        opts = {},
	},
	{
		"danymat/neogen",
		dependencies = "nvim-treesitter/nvim-treesitter",
		cmd = "Neogen",
		opts = {
			enabled = true,
			languages = {
				c = {
					template = {
						annotation_convention = "doxygen",
					},
				},
				cpp = {
					template = {
						annotation_convention = "doxygen",
					},
				},
				python = {
					template = {
						annotation_convention = "google_docstrings",
					},
				},
			},
		},
	},
	{
		"mzlogin/vim-markdown-toc",
		ft = "markdown",
	},
}
