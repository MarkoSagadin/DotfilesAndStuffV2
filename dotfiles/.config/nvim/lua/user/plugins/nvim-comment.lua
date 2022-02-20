local status_ok, nvim_comment = pcall(require, "nvim_comment")
if not status_ok then
	return
end

local opts = {
	-- Linters prefer comment and line to have a space in between markers
	marker_padding = true,
	-- should comment out empty or whitespace only lines
	comment_empty = false,
	-- Should key mappings be created
	create_mappings = true,
	-- Normal mode mapping left hand side
	line_mapping = "<leader>ll",
	-- Visual/Operator mapping left hand side
	operator_mapping = "<leader>l",
	-- Hook function to call before commenting takes place
	hook = function()
		local filetype = vim.api.nvim_buf_get_option(0, "filetype")
		-- Change commentstring for c and h files
		if filetype == "c" or filetype == "h" then
			vim.api.nvim_buf_set_option(0, "commentstring", "// %s")
		end
	end,
}

nvim_comment.setup(opts)
