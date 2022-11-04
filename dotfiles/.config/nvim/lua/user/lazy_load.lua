-- Copied from https://github.com/NvChad/NvChad/
local M = {}
local autocmd = vim.api.nvim_create_autocmd

M.packer_cmds = {
	"PackerSnapshot",
	"PackerSnapshotRollback",
	"PackerSnapshotDelete",
	"PackerInstall",
	"PackerUpdate",
	"PackerSync",
	"PackerClean",
	"PackerCompile",
	"PackerStatus",
	"PackerProfile",
	"PackerLoad",
}

M.mason_cmds = { "Mason", "MasonInstall", "MasonInstallAll", "MasonUninstall", "MasonUninstallAll", "MasonLog" }

M.gitsigns = function()
	autocmd({ "BufRead" }, {
		group = vim.api.nvim_create_augroup("GitSignsLazyLoad", { clear = true }),
		callback = function()
			vim.fn.system("git rev-parse " .. vim.fn.expand("%:p:h"))
			if vim.v.shell_error == 0 then
				vim.api.nvim_del_augroup_by_name("GitSignsLazyLoad")
				vim.schedule(function()
					require("packer").loader("gitsigns.nvim")
				end)
			end
		end,
	})
end

return M
