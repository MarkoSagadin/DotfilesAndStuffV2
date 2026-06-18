-- Helpers, because who has time to write all of this.
-- Also, move wrappers, redraw the screen with cursor on top
local function keymap_select(map, capture_group)
	vim.keymap.set({ "x", "o" }, map, function()
		require("nvim-treesitter-textobjects.select").select_textobject(capture_group, "textobjects")
	end)
end

local function keymap_move_to_next_start(map, capture_group)
	vim.keymap.set({ "n", "x", "o" }, map, function()
		require("nvim-treesitter-textobjects.move").goto_next_start(capture_group, "textobjects")
		vim.cmd.normal("zt")
	end)
end

local function keymap_move_to_prev_start(map, capture_group)
	vim.keymap.set({ "n", "x", "o" }, map, function()
		require("nvim-treesitter-textobjects.move").goto_previous_start(capture_group, "textobjects")
		vim.cmd.normal("zt")
	end)
end

local function keymap_move_to_next_end(map, capture_group)
	vim.keymap.set({ "n", "x", "o" }, map, function()
		require("nvim-treesitter-textobjects.move").goto_next_end(capture_group, "textobjects")
		vim.cmd.normal("zt")
	end)
end

local function keymap_move_to_prev_end(map, capture_group)
	vim.keymap.set({ "n", "x", "o" }, map, function()
		require("nvim-treesitter-textobjects.move").goto_previous_end(capture_group, "textobjects")
		vim.cmd.normal("zt")
	end)
end

return {
	{
		"nvim-treesitter/nvim-treesitter",
		event = { "BufReadPost", "BufNewFile" },
		cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
		build = ":TSUpdate",
		dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
		init = function()
			vim.api.nvim_create_autocmd("FileType", {
				callback = function()
					-- Enable treesitter highlighting and disable regex syntax
					pcall(vim.treesitter.start)
					-- Enable treesitter-based indentation
					vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
				end,
			})
			local ensure_installed = {
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
				"go",
			}
			require("nvim-treesitter").install(ensure_installed)
		end,
	},

	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		branch = "main",
		init = function()
			-- Disable entire built-in ftplugin mappings to avoid conflicts.
			-- See https://github.com/neovim/neovim/tree/master/runtime/ftplugin for built-in ftplugins.
			vim.g.no_plugin_maps = true

			-- keymaps
			keymap_select("af", "@function.outer")
			keymap_select("if", "@function.inner")
			keymap_select("ab", "@block.outer")
			keymap_select("ib", "@block.inner")

			keymap_move_to_next_start("]m", "@function.outer")
			keymap_move_to_prev_start("[m", "@function.outer")

			keymap_move_to_next_end("]M", "@function.inner")
			keymap_move_to_prev_end("[M", "@function.inner")

			keymap_move_to_next_start("]]", "@class.outer")
			keymap_move_to_prev_start("[[", "@class.outer")

			keymap_move_to_next_start("]d", "@conditional.outer")
			keymap_move_to_prev_start("[d", "@conditional.outer")
		end,
	},
}
