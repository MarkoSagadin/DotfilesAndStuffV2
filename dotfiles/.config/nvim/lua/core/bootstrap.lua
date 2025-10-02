------------------------
-- Bootstrap
------------------------
local fn = vim.fn

-- Install Lazy package manager, if not installed already.
local lazy_path = fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazy_path) then
	local lazy_repo = "https://github.com/folke/lazy.nvim.git"

	vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#1e222a" })

	print("  Installing lazy.nvim & plugins ...")
	fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"--branch=stable", -- latest stable release
		lazy_repo,
		lazy_path,
	})

	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
	vim.api.nvim_create_autocmd("User", {
		pattern = "LazyDone",
		callback = function()
			vim.defer_fn(function()
				-- Quit Lazy window
				vim.cmd("q")
				-- Open Mason, which will install all programs
				vim.cmd("Mason")
			end, 100)
		end,
	})
end
vim.opt.rtp:prepend(lazy_path)
