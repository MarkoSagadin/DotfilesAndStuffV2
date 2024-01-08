local components = require("ui.components")

require("lualine").setup({
	options = {
		icons_enabled = true,
		theme = "auto",
		component_separators = { left = "", right = "" },
		section_separators = { left = "", right = "" },
		disabled_filetypes = { "dashboard", "NvimTree", "Outline" },
	},
	sections = {
		lualine_a = {
			components.mode,
		},
		lualine_b = {
			components.branch,
			components.filename,
		},
		lualine_c = {
			components.diff,
			components.python_env,
		},
		lualine_x = {
			components.diagnostics,
			components.treesitter,
			components.lsp,
		},
		lualine_y = {
			components.filetype,
			components.spaces,
			components.fileformat,
		},
		lualine_z = {
			components.location,
		},
	},
	inactive_sections = {
		lualine_a = {
			"filename",
		},
		lualine_b = {},
		lualine_c = {},
		lualine_x = {},
		lualine_y = {},
		lualine_z = {},
	},
	tabline = {},
	extensions = { "nvim-tree" },
})
