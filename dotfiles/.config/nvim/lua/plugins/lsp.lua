return {
	{
		"williamboman/mason.nvim",
		cmd = { "Mason", "MasonInstall", "MasonInstallAll", "MasonUpdate" },

		opts = {
			ensure_installed = {
				-- Linters and formatters
				"ruff",
				"stylua",
				"luacheck",
				"clang-format",
				"fixjson",
				"shfmt",
				"cmakelang", -- cmake-format, cmake-lint, cmake
				"vale",
				"hadolint",
				"markdownlint",
				"prettierd",
				-- LSPs
				"bash-language-server",
				"pyright",
				"jsonld-lsp",
				"yaml-language-server",
				"clangd",
				"cmake-language-server",
				"lua-language-server",
			},

			PATH = "prepend", -- "skip" seems to cause the spawning error

			ui = {
				icons = {
					package_pending = " ",
					package_installed = "󰄳 ",
					package_uninstalled = " 󰚌",
				},
			},
		},

		config = function(_, opts)
			require("mason").setup(opts)

			-- custom nvchad cmd to install all mason binaries listed
			vim.api.nvim_create_user_command("MasonInstallAll", function()
				vim.cmd("MasonInstall " .. table.concat(opts.ensure_installed, " "))
			end, {})
		end,
	},

	{
		"neovim/nvim-lspconfig",
		init = function()
			require("utils").lazy_load("nvim-lspconfig")
		end,
		dependencies = {
			{ "folke/neodev.nvim", opts = {} },
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
		},
		config = function()
			require("lsp")
		end,
	},
}
