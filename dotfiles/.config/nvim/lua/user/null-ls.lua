local status_ok, null_ls = pcall(require, "null-ls")
if not status_ok then
	return
end

-- This paths are found in the null-ls GitHub repo
local fmt = null_ls.builtins.formatting
local diag = null_ls.builtins.diagnostics

-- https://github.com/prettier-solidity/prettier-plugin-solidity
-- npm install --save-dev prettier prettier-plugin-solidity
null_ls.setup({
	-- Displays all possible log messages and writes them to the null-ls log,
	-- which you can view with the command :NullLsLog.
	-- This option can slow down Neovim, so it's strongly recommended to disable
	-- it for normal use.
	debug = false,

	-- Below chunk will perform formating on save
	on_attach = function(client)
		if client.resolved_capabilities.document_formatting then
			vim.cmd("autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()")
		end
	end,

	sources = {
		-- Formaters
		fmt.black.with({ extra_args = { "--preview" } }),
		fmt.stylua.with({ extra_args = { "--quote-style", "ForceDouble" } }),
		fmt.clang_format,
		fmt.fixjson,
		fmt.shfmt,
		fmt.cmake_format,

		-- Diagnostics aka. Linters
		diag.flake8.with({ extra_args = { "--max-line-length=88" } }),
		diag.luacheck.with({ extra_args = { "--globals", "vim" } }),
		diag.vale,
		diag.hadolint,
	},
})
