return {
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
		},
	},
    -- {
    --   "nvim-telescope/telescope-frecency.nvim",
    --   config = function()
    --     require("telescope").load_extension "frecency"
    --   end,
    -- }
}
