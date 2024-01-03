return {
	"nvim-treesitter/nvim-treesitter",
	init = function()
		require("utils").lazy_load("nvim-treesitter")
	end,
	cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
	build = ":TSUpdate",
	dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
	config = function(_, opts)
		local configs = require("nvim-treesitter.configs")
		configs.setup(opts)
	end,
	opts = {
		ensure_installed = {
			"markdown",
			"latex",
			"devicetree",
			"dockerfile",
			"bash",
			"c",
			"cpp",
			"javascript",
			"json",
			"lua",
			"python",
			"typescript",
			"css",
			"rust",
			"yaml",
			"nix",
		},

		-- Install languages synchronously (only applied to `ensure_installed`)
		sync_install = false,

		highlight = {
			-- `false` will disable the whole extension
			enable = true,

			-- Disable slow treesitter highlight for large files
			disable = function(_, buf)
				local max_filesize = 60 * 1024 -- 60 KB
				local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
				if ok and stats and stats.size > max_filesize then
					return true
				end
			end,
			-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
			-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
			-- Using this option may slow down your editor, and you may see some duplicate highlights.
			-- Instead of true it can also be a list of languages
			additional_vim_regex_highlighting = true,
		},
		indent = {
			enable = true,
		},
		incremental_selection = {
			enable = true,
			keymaps = {
				init_selection = "gnn",
				node_incremental = "grn",
				scope_incremental = "grc",
				node_decremental = "grm",
			},
		},
		textobjects = {
			select = {
				enable = true,
				-- Automatically jump forward to textobj, similar to targets.vim
				lookahead = true,
				keymaps = {
					-- You can use the capture groups defined in textobjects.scm
					["af"] = "@function.outer",
					["if"] = "@function.inner",
					["ab"] = "@block.outer",
					["ib"] = "@block.inner",
				},
				include_surrounding_whitespace = true,
			},
			move = {
				enable = true,
				-- whether to set jumps in the jumplist
				set_jumps = true,
				goto_next_start = {
					["]]"] = "@function.outer",
				},
				goto_next_end = {
					["]["] = "@function.outer",
				},
				goto_previous_start = {
					["[["] = "@function.outer",
				},
				goto_previous_end = {
					["[]"] = "@function.outer",
				},
			},
			swap = {
				enable = true,
				swap_next = {
					["<leader>a"] = "@parameter.inner",
				},
				swap_previous = {
					["<leader>A"] = "@parameter.inner",
				},
			},
		},
	},
}
