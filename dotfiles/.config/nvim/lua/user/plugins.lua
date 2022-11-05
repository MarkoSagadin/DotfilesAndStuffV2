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

	-- TODO: Figure out how to lazy_load or replace
	use({
		"gbprod/substitute.nvim",
		opt = true,
		module = "substitute",
		config = function()
			require("substitute").setup({
				-- your configuration comes here
				-- or leave it empty to use the default settings
				-- refer to the configuration section below
			})
		end,
	})
	-- use("windwp/nvim-autopairs")
	-- use("ThePrimeagen/harpoon")

	-- use("folke/which-key.nvim")

	-- Some commenting plugins
	use({
		"terrortylor/nvim-comment",
		cmd = "CommentToggle",
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
		event = "VimEnter",
		config = function()
			require("tmux").setup({
				-- We want to use this pluging only for naviagtion,
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
		event = "BufReadPost",
		config = "require('user.treesitter')",
	})
	use({ "nvim-treesitter/nvim-treesitter-textobjects", requires = { { "nvim-treesitter/nvim-treesitter" } } })
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

	use("jose-elias-alvarez/null-ls.nvim")
	use("ludovicchabant/vim-gutentags")

    -- Completion plugins, snippet engine and snippets
	use({ "hrsh7th/nvim-cmp", event = "InsertEnter", config = "require('user.cmp')" })
	use({ "hrsh7th/cmp-nvim-lua", after = "nvim-cmp" })
	use({ "hrsh7th/cmp-nvim-lsp", after = "cmp-nvim-lua" })
	use({ "hrsh7th/cmp-buffer", after = "cmp-nvim-lsp" })
	use({ "hrsh7th/cmp-path", after = "cmp-buffer" })
	use({ "hrsh7th/cmp-cmdline", after = "cmp-path" })
	use({ "saadparwaiz1/cmp_luasnip", after = "cmp-cmdline" })
	use({ "L3MON4D3/LuaSnip", after = "cmp_luasnip", requires = "rafamadriz/friendly-snippets" })

	-- Installers for LSP, Formatters, Linters
	use({
		"williamboman/mason.nvim",
		config = "require('user.lsp.mason').setup()",
	})
	use({ "jayp0521/mason-null-ls.nvim" })
	use({ "williamboman/mason-lspconfig.nvim" })

	-- LSP
	use({
		"neovim/nvim-lspconfig",
		opt = true,
		event = "BufReadPre",
		config = "require('user.lsp')",
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
