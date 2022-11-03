local fn = vim.fn
local install_path = fn.stdpath("data") .. "/site/pack/packer/opt/packer.nvim"

-- This block will execute only on fresh install
if fn.empty(fn.glob(install_path)) > 0 then
	vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#1e222a" })
	print("Cloning Packer...")
	fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })

	-- install plugins + compile their configs
	vim.cmd("packadd packer.nvim")
	require("user.plugins")
	vim.cmd("PackerSync")

	-- Install binaries from mason.nvim & treesitter parsers after Packer is done
	vim.api.nvim_create_autocmd("User", {
		pattern = "PackerComplete",
		callback = function()
			-- This will close Packer window and install everything
			vim.cmd("colorscheme dracula")
			vim.cmd("bw | silent! Mason")
			require("packer").loader("nvim-treesitter")
		end,
	})
end
