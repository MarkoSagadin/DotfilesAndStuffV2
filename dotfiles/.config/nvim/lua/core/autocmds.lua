------------------------
-- Autocommands
------------------------

--- Trim trailing whitespace
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
	pattern = { "*" },
	callback = function(_)
		-- Save cursor position to later restore
		local curpos = vim.api.nvim_win_get_cursor(0)
		-- Search and replace trailing whitespace
		vim.cmd([[keeppatterns %s/\s\+$//e]])
		vim.api.nvim_win_set_cursor(0, curpos)
	end,
})

local function change_file_type(pattern, new_file_type)
	vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
		pattern = { pattern },
		command = "setf " .. new_file_type,
	})
end

-- Change the filetypes for the pattern on the left to the file type on the
-- right. Most common reason is usually syntax highlighting.
change_file_type("[Dd]ockerfile*", "dockerfile")
change_file_type("*.ino", "cpp")
change_file_type("*.h", "c")
change_file_type("*.rasi", "css")
change_file_type("*.overlay", "devicetree")
change_file_type("*.conf", "kconfig")

-- Set spelling language for markdown and gitcommit
vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = { "markdown,gitcommit" },
	command = "setlocal spell spelllang=en_gb",
})

-- Open help and man files on the right vertical split
vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = { "help,man" },
	command = "wincmd L",
})

-- Tell neovim where to look for python provider, startups that require python
-- tooling are faster
vim.cmd("let g:python3_host_prog = '/usr/bin/python3'")
