return {
	{
		"nvim-telescope/telescope.nvim",
		cmd = "Telescope",
		dependencies = {
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
				config = function()
					require("telescope").load_extension("fzf")
				end,
			},
		},
		opts = {
			defaults = {
				prompt_prefix = " ",
				selection_caret = " ",
				path_display = { "smart" },
			},
			pickers = {
				current_buffer_fuzzy_find = {
					previewer = false,
					theme = "dropdown",
				},
				git_files = {
					previewer = false,
					theme = "dropdown",
				},
				buffers = {
					previewer = false,
					theme = "dropdown",
				},
			},
			extensions = {
				fzf = {
					fuzzy = true, -- false will only do exact matching
					override_generic_sorter = true,
					override_file_sorter = true,
					case_mode = "smart_case", -- or "ignore_case" or "respect_case"
				},
				hierarchy = {},
			},
		},
	},
	{
		"jmacadie/telescope-hierarchy.nvim",
		dependencies = {
			{
				"nvim-telescope/telescope.nvim",
				dependencies = { "nvim-lua/plenary.nvim" },
			},
		},
		keys = {
			{
				"<leader>si",
				"<cmd>Telescope hierarchy incoming_calls<cr>",
				desc = "LSP: [S]earch [I]ncoming Calls",
			},
			{
				"<leader>so",
				"<cmd>Telescope hierarchy outgoing_calls<cr>",
				desc = "LSP: [S]earch [O]utgoing Calls",
			},
		},
		config = function(_, opts)
			require("telescope").load_extension("hierarchy")
		end,
	},
	{
		"nvim-telescope/telescope-frecency.nvim",
		config = function()
			require("telescope").load_extension("frecency")
		end,
	},
}
