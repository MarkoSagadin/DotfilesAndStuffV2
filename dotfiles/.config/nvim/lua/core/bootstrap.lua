------------------------
-- Bootstrap
------------------------
local fn = vim.fn

-- Install Lazy package manager, if not installed already.
local lazy_path = fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazy_path) then
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
	vim.api.nvim_create_autocmd("User", {
		pattern = "LazyDone",
		callback = function()
			vim.defer_fn(function()
				-- Quit Lazy window
				vim.cmd("q")
				-- Install all programs with Mason
				vim.cmd("MasonInstallAll")
			end, 100)
		end,
	})
end
vim.opt.rtp:prepend(lazy_path)
