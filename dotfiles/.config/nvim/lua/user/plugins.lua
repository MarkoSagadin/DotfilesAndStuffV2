------------------------
-- Plugins
------------------------

-- All plugins that need to be installed
local plugin_fun = function(use)
	-- Have packer manage itself
	use({
		"wbthomason/packer.nvim",
		cmd = require("user.lazy_load").packer_cmds,
		config = "require('user.plugins')",
	})

	-- Lua Library used by many plugins
	use({ "nvim-lua/plenary.nvim", module = "plenary" })

	-- Call it the first thing in the main init.lua
	use({ "lewis6991/impatient.nvim" })
	use({ "dstein64/vim-startuptime" })
	use({ "tpope/vim-fugitive" })

	use({
		"karb94/neoscroll.nvim",
		opt = true,
		keys = { "<C-a>", "<C-d>" },
		config = "require('user.plugins.neoscroll')",
	})

	use({
		"nvim-lualine/lualine.nvim",
		event = "VimEnter",
		config = "require('user.lualine')",
		requires = { "kyazdani42/nvim-web-devicons" },
	})

	use({
		"cappyzawa/trim.nvim",
		opt = true,
		events = "BufWrite",
		config = function()
			require("trim").setup({
				patterns = {
					[[%s/\s\+$//e]], -- Trim away just trailing whitespace
				},
			})
		end,
	})

	use({
		"gbprod/substitute.nvim",
		opt = true,
		module = "substitute",
		config = "require('substitute').setup()",
	})
	use({
		"windwp/nvim-autopairs",
		config = function()
			require("nvim-autopairs").setup({})
		end,
	})
	use("ThePrimeagen/harpoon")

	-- use("folke/which-key.nvim")

	-- Some commenting plugins
	use({
		"terrortylor/nvim-comment",
		config = "require('user.comments').nvim_comment_setup()",
	})
	use({
		"folke/todo-comments.nvim",
		opt = true,
		event = { "BufRead", "BufNewFile" },
		config = "require('todo-comments').setup()",
	})
	use({
		"danymat/neogen",
		requires = "nvim-treesitter/nvim-treesitter",
		cmd = "Neogen",
		config = "require('user.comments').neogen_setup()",
	})

	use({ "iamcco/markdown-preview.nvim", ft = "markdown", run = "cd app && yarn install" })
	-- TODO: Figure out how to lazy_load or replace with lua
	use({ "mzlogin/vim-markdown-toc", ft = "markdown", cmd = "GenTocGFM" })

	use({ "kyazdani42/nvim-tree.lua", cmd = "NvimTreeToggle", config = "require('user.plugins.nvim-tree')" })

	use({
		"aserowy/tmux.nvim",
		keys = { "<C-h>", "<C-j>", "<C-k>", "<C-l>" },
		config = function()
			require("tmux").setup({
				-- We want to use this plugin only for naviagtion,
				-- copy_sync feature only messes up the perfectly fine
				-- "copy to clipboard" behavoiur.
				copy_sync = { enable = false },
			})
		end,
	})

	use({
		"lewis6991/gitsigns.nvim",
		ft = "gitcommit",
		setup = "require('user.lazy_load').gitsigns()",
		config = "require('user.plugins.gitsigns')",
	})

	use({
		"nvim-treesitter/nvim-treesitter",
		run = ":TSUpdate",
		config = "require('user.treesitter')",
		setup = function()
			require("user.lazy_load").on_file_open("nvim-treesitter")
		end,
		cmd = require("user.lazy_load").treesitter_cmds,
	})
	use({
		"nvim-treesitter/nvim-treesitter-textobjects",
		after = "nvim-treesitter",
		requires = "nvim-treesitter/nvim-treesitter",
	})
	use({
		"nvim-telescope/telescope.nvim",
		cmd = "Telescope",
		config = "require('user.plugins.telescope')",
	})

	use({
		"nvim-telescope/telescope-fzf-native.nvim",
		after = "telescope.nvim",
		run = "make",
		config = function()
			require("telescope").load_extension("fzf")
		end,
	})

	use({
		"jose-elias-alvarez/null-ls.nvim",
		setup = function()
			require("user.lazy_load").on_file_open("null-ls.nvim")
		end,
		config = function()
			require("user.lsp.null-ls")
		end,
	})
	-- use("ludovicchabant/vim-gutentags")

	-- Completion plugins, snippet engine and snippets
	use({ "hrsh7th/nvim-cmp", event = "InsertEnter", config = "require('user.cmp')" })
	use({ "hrsh7th/cmp-nvim-lua", after = "nvim-cmp" })
	use({ "hrsh7th/cmp-nvim-lsp", after = "cmp-nvim-lua" })
	use({ "hrsh7th/cmp-buffer", after = "cmp-nvim-lsp" })
	use({ "hrsh7th/cmp-path", after = "cmp-buffer" })
	use({ "hrsh7th/cmp-cmdline", after = "cmp-path" })
	use({ "saadparwaiz1/cmp_luasnip", after = "cmp-cmdline" })
	use({ "hrsh7th/cmp-copilot", after = "saadparwaiz1/cmp_luasnip" })
	use({
		"L3MON4D3/LuaSnip",
		after = "cmp_luasnip",
		requires = "rafamadriz/friendly-snippets",
		config = "require('user.snippets')",
	})

	-- Installers for LSP, Formatters, Linters
	use({ "williamboman/mason.nvim" })
	use({ "jayp0521/mason-null-ls.nvim" })
	use({ "williamboman/mason-lspconfig.nvim" })

	-- LSP
	use({
		"neovim/nvim-lspconfig",
		opt = true,
		event = "BufReadPre",
		config = "require('user.lsp')",
	})

	use({
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = "InsertEnter",
		config = function()
			require("copilot").setup({})
		end,
	})
	-- use("folke/lua-dev.nvim")

	-- -- Debugging
	-- use("sakhnik/nvim-gdb")
	-- use("mfussenegger/nvim-dap")
	-- use("rcarriga/nvim-dap-ui")

	-- -- Formatters

	-- -- Colorschemes
	-- use("tjdevries/colorbuddy.nvim")
	-- use("bbenzikry/snazzybuddy.nvim")
	-- use("rktjmp/lush.nvim") -- Colorscheme creation plugin
	-- use("Mofiqul/dracula.nvim")
	use("folke/tokyonight.nvim")
	use("dracula/vim")
	-- use("ellisonleao/gruvbox.nvim")
	use("xiyaowong/nvim-transparent")
end

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
	return
end

-- Have Packer use a popup window
packer.init({
	auto_clean = true,
	compile_on_sync = true,
	display = {
		open_fn = function()
			return require("packer.util").float({ border = "rounded" })
		end,
	},
})
packer.startup(plugin_fun)
