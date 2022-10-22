local status_ok, null_ls = pcall(require, "null-ls")
if not status_ok then
	return
end

-- This paths are found in the null-ls GitHub repo
local fmt = null_ls.builtins.formatting
local diag = null_ls.builtins.diagnostics

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

-- This will make sure that we are always using null-ls (and its sources)
-- for formatting and linting.
local lsp_formatting = function(bufnr)
	vim.lsp.buf.format({
		filter = function(client)
			return client.name == "null-ls"
		end,
		bufnr = bufnr,
	})
end

null_ls.setup({
	-- Displays all possible log messages and writes them to the null-ls log,
	-- which you can view with the command :NullLsLog.
	-- This option can slow down Neovim, so it's strongly recommended to disable
	-- it for normal use.
	debug = false,

	-- Whole on_attach callback was copied from null-ls's wiki
	-- Below chunk will perform formating on save
	on_attach = function(client, bufnr)
		if client.supports_method("textDocument/formatting") then
			vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = augroup,
				buffer = bufnr,
				callback = function()
					lsp_formatting(bufnr)
				end,
			})
		end
	end,

	sources = {
		-- Formaters
		-- isort will run before black, as it is listed before it.
		fmt.isort,
		fmt.black.with({ extra_args = { "--preview" } }),
		fmt.stylua.with({ extra_args = { "--quote-style", "ForceDouble" } }),
		fmt.clang_format,
		fmt.shfmt,
		fmt.cmake_format,
		-- Prettierd is a faster, deamon, version of prettier.
		-- You can not set arguments for it from here, this has to be done by
		-- setting PRETTIERD_DEFAULT_CONFIG env virable to the .prettierrc file
		-- Right now I only set equvivalent of below:
		-- extra_args = { "--prose-wrap", "always" },
		fmt.prettierd.with({
			filetypes = { "js", "html", "yaml", "markdown" },
		}),

		-- Diagnostics aka. Linters
		diag.flake8.with({ extra_args = { "--max-line-length=88" } }),
		diag.luacheck.with({ extra_args = { "--globals", "vim" } }),
		diag.vale,
		diag.hadolint,
	},
})
