local status_ok_nvim_comment, nvim_comment = pcall(require, "nvim_comment")
if not status_ok_nvim_comment then
	return
end
local status_ok_todo_comments, todo_comments = pcall(require, "todo-comments")
if not status_ok_todo_comments then
	return
end
local status_ok_neogen, neogen = pcall(require, "neogen")
if not status_ok_neogen then
	return
end

local nvim_comment_opts = {
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

local neogen_opts = {
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
}

nvim_comment.setup(nvim_comment_opts)
todo_comments.setup()
neogen.setup(neogen_opts)
