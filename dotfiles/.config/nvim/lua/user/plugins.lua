------------------------
-- Plugins
------------------------

-- Bootstrap packer, copied from https://github.com/wbthomason/packer.nvim
local fn = vim.fn
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
local packer_bootstrap
if fn.empty(fn.glob(install_path)) > 0 then
	packer_bootstrap = fn.system({
		"git",
		"clone",
		"--depth",
		"1",
		"https://github.com/wbthomason/packer.nvim",
		install_path,
	})
	print("Installing Packer, close and reopen Neovim...")
	vim.cmd([[packadd packer.nvim]])
end

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
	return
end

-- Have Packer use a popup window
packer.init({
	display = {
		open_fn = function()
			return require("packer.util").float({ border = "rounded" })
		end,
	},
})

-- All plugins that need to be installed
return require("packer").startup(function(use)
	use("wbthomason/packer.nvim") -- Have packer manage itself
	use("nvim-lua/plenary.nvim") -- Lua Library used by many plugins

	use("dstein64/vim-startuptime")

	use("karb94/neoscroll.nvim")
	use("nvim-lualine/lualine.nvim")
	use("cappyzawa/trim.nvim")
	use("svermeulen/vim-subversive")
	use("windwp/nvim-autopairs")
	use("ThePrimeagen/harpoon")
	use("xiyaowong/nvim-transparent")

	use("folke/which-key.nvim")

	-- Some commenting plugins
	use("terrortylor/nvim-comment")
	use("folke/todo-comments.nvim")
	use("danymat/neogen")

	-- Lazy load this one so it loads only on MarkdownPreview
	use({ "iamcco/markdown-preview.nvim", ft = "markdown", run = "cd app && yarn install" })

	use("mzlogin/vim-markdown-toc")

	use({ "kyazdani42/nvim-tree.lua" })
	use({ "liuchengxu/vista.vim" })

	use("aserowy/tmux.nvim")
	use("lewis6991/gitsigns.nvim")
	use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" })
	use("nvim-treesitter/nvim-treesitter-textobjects")
	use("nvim-telescope/telescope.nvim")
	use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" })
	use("jose-elias-alvarez/null-ls.nvim")
	use("ludovicchabant/vim-gutentags")

	-- Completion plugins
	use("hrsh7th/nvim-cmp")
	use("hrsh7th/cmp-buffer")
	use("hrsh7th/cmp-path")
	use("hrsh7th/cmp-cmdline")
	use("hrsh7th/cmp-nvim-lua")
	use("saadparwaiz1/cmp_luasnip")
	use("hrsh7th/cmp-nvim-lsp")

	-- LSP
	use("neovim/nvim-lspconfig")
	use("williamboman/nvim-lsp-installer")
	use("folke/lua-dev.nvim")

	-- snippet pluggins
	use("L3MON4D3/LuaSnip")
	use("rafamadriz/friendly-snippets")

	-- Snippets

	-- Colorschemes
	use("tjdevries/colorbuddy.nvim")
	use("bbenzikry/snazzybuddy.nvim")
	use("shaunsingh/moonlight.nvim")
	use("rktjmp/lush.nvim") -- Colorscheme creation plugin
	use("dracula/vim")
	use("ellisonleao/gruvbox.nvim")

	-- Automatically set up your configuration after cloning packer.nvim
	-- Put this at the end after all plugins
	if packer_bootstrap then
		require("packer").sync()
	end
end)
