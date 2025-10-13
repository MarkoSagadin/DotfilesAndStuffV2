return {
	{
		"mason-org/mason.nvim",
		cmd = { "Mason", "MasonInstall", "MasonInstallAll", "MasonUpdate" },
		build = ":MasonUpdate",
		opts_extend = { "ensure_installed" },
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
				"gofumpt",
				-- LSPs
				"bash-language-server",
				"pyright",
				"jsonld-lsp",
				"yaml-language-server",
				"clangd",
				"cmake-language-server",
				"lua-language-server",
				"typescript-language-server",
				"gopls",
				"ginko_ls", -- DeviceTree LSP
			},
			ui = {
				border = "rounded",
				icons = {
					package_pending = " ",
					package_installed = "󰄳 ",
					package_uninstalled = " ",
				},
			},
		},
		-- Below will make sure that all programs in the ensure_installed are
		-- installed.
		config = function(_, opts)
			require("mason").setup(opts)
			local mr = require("mason-registry")
			mr:on("package:install:success", function()
				vim.defer_fn(function()
					-- trigger FileType event to possibly load this newly installed LSP server
					require("lazy.core.handler.event").trigger({
						event = "FileType",
						buf = vim.api.nvim_get_current_buf(),
					})
				end, 100)
			end)

			mr.refresh(function()
				for _, tool in ipairs(opts.ensure_installed) do
					local p = mr.get_package(tool)
					if not p:is_installed() then
						p:install()
					end
				end
			end)
		end,
	},
	{
		"neovim/nvim-lspconfig",
		-- With below line my personal lsp settings are loaded from lsp dir.
		lazy = false,
		config = function(_, _)
			require("lsp")
		end,
		opts = {
			-- Enable this to enable the builtin LSP code lenses on Neovim.
			-- Be aware that you also will need to properly configure your LSP server to
			-- provide the code lenses.
			codelens = {
				enabled = true,
			},
		},
	},
	{
		"mason-org/mason-lspconfig.nvim",
		event = { "VeryLazy" },
		dependencies = {
			"neovim/nvim-lspconfig",
		},
		opts = {},
	},
	{
		"folke/lazydev.nvim",
		ft = "lua", -- only load on lua files
		opts = {
			library = {
				-- See the configuration section for more details
				-- Load luvit types when the `vim.uv` word is found
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
		},
	},
}
