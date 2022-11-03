M = {}
M.nvim_comment_setup = function()
	require("nvim_comment").setup({
		-- should comment out empty or whitespace only lines
		comment_empty = false,
		-- Hook function to call before commenting takes place
		hook = function()
			local filetype = vim.api.nvim_buf_get_option(0, "filetype")
			-- Change commentstring for c and h files
			if filetype == "c" or filetype == "h" then
				vim.api.nvim_buf_set_option(0, "commentstring", "// %s")
			end
		end,
	})
end

M.neogen_setup = function()
	require("neogen").setup({
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
	})
end
return M
