return {
	{
		"mfussenegger/nvim-lint",
		init = function()
			require("utils").lazy_load("nvim-lint")
		end,
		config = function(_, _)
			local lint = require("lint")

			-- Set linters by the file type
			lint.linters_by_ft = {
				markdown = { "vale" },
				dockerfile = { "hadolint" },
				lua = { "luacheck" },
				python = { "ruff" },
			}

			-- Set specific settings for each linter
			local luacheck = lint.linters.luacheck
			luacheck.args = { "--globals", "vim" }

			local lint_augroup = vim.api.nvim_create_augroup("lint", {
				clear = true,
			})
			vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
				group = lint_augroup,
				callback = function()
					lint.try_lint()
				end,
			})
		end,
	},
}
