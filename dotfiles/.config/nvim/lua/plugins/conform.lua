return {
	"stevearc/conform.nvim",
	cmd = { "ConformInfo" },
	dependencies = {
		"williamboman/mason.nvim",
	},
	-- Everything in opts will be passed to setup()
	opts = {
		-- Define your formatters
		formatters_by_ft = {
			lua = { "stylua" },
			python = {
				-- To run the Ruff formatter.
				"ruff_format",
			},
			javascript = { "prettierd" },
			html = { "prettierd" },
			yaml = { "prettierd" },
			markdown = { "prettierd" },
			typescript = { "prettierd" },
			typescriptreact = { "prettierd" },
			sh = { "shfmt" },
			cmake = { "cmake_format" },
			c = { "clang_format" },
			cpp = { "clang_format" },
			rust = { "rustfmt" },
			go = { "gofumpt" },
		},
		format_on_save = {
			lsp_format = "fallback",
			timeout_ms = 500,
		},
		format_after_save = {
			lsp_format = "fallback",
		},
		-- Customize formatters
		formatters = {
			isort = {
				prepend_args = { "--profile", "black" },
			},
			stylua = {
				prepend_args = { "--quote-style", "ForceDouble" },
			},
			rustfmt = {
				prepend_args = { "--edition", "2021" },
			},
		},
	},
	init = function()
		require("utils").lazy_load("conform.nvim")
		vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
	end,
}
