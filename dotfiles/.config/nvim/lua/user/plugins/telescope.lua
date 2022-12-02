local status_ok, telescope = pcall(require, "telescope")
if not status_ok then
	return
end

telescope.setup({
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
			override_generic_sorter = true, -- override the generic sorter
			override_file_sorter = true, -- override the file sorter
			case_mode = "smart_case", -- or "ignore_case" or "respect_case"
			-- the default case_mode is "smart_case"
		},
	},
})

local M = {}

-- Fall back to find_files if git_files can't find a .git directory
M.project_files = function()
	local opts = {} -- define here if you want to define something
	vim.fn.system("git rev-parse --is-inside-work-tree")
	if vim.v.shell_error == 0 then
		require("telescope.builtin").git_files(opts)
	else
		require("telescope.builtin").find_files(opts)
	end
end

return M
