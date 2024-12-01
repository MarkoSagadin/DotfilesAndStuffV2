local conditions = require("ui.conditionals")
local colors = require("ui.colors")

-- Helper functions
local function diff_source()
	local gitsigns = vim.b.gitsigns_status_dict
	if gitsigns then
		return {
			added = gitsigns.added,
			modified = gitsigns.changed,
			removed = gitsigns.removed,
		}
	end
end

local function list_registered_providers_names(filetype)
	local s = require("null-ls.sources")
	local available_sources = s.get_available(filetype)
	local registered = {}
	for _, source in ipairs(available_sources) do
		for method in pairs(source.methods) do
			registered[method] = registered[method] or {}
			table.insert(registered[method], source.name)
		end
	end
	return registered
end

-- provider argument can only be FORMATTING or DIAGNOSTICS, this function is
-- used to get the names of currenlty used formatters and linters
local function list_registered_providers(filetype, provider)
	local null_ls_methods = require("null-ls.methods")
	local selected_method = null_ls_methods.internal[provider]
	local registered_providers = list_registered_providers_names(filetype)
	return registered_providers[selected_method] or {}
end

return {
	mode = {
		function()
			return "  "
		end,
		padding = { left = 0, right = 0 },
		color = {},
		cond = nil,
	},
	branch = {
		"b:gitsigns_head",
		icon = " ",
		color = { gui = "bold" },
		cond = conditions.hide_in_width,
	},
	filename = {
		"filename",
		color = {},
		cond = nil,
	},
	diff = {
		"diff",
		source = diff_source,
		symbols = { added = "  ", modified = " ", removed = " " },
		diff_color = {
			added = { fg = colors.green },
			modified = { fg = colors.yellow },
			removed = { fg = colors.red },
		},
		color = {},
		cond = nil,
	},
	python_env = {
		function()
			local utils = require("lvim.core.lualine.utils")
			if vim.bo.filetype == "python" then
				local venv = os.getenv("CONDA_DEFAULT_ENV")
				if venv then
					return string.format("  (%s)", utils.env_cleanup(venv))
				end
				venv = os.getenv("VIRTUAL_ENV")
				if venv then
					return string.format("  (%s)", utils.env_cleanup(venv))
				end
				return ""
			end
			return ""
		end,
		color = { fg = colors.green },
		cond = conditions.hide_in_width,
	},
	diagnostics = {
		"diagnostics",
		sources = { "nvim_diagnostic" },
		symbols = { error = " ", warn = " ", info = " ", hint = " " },
		color = {},
		cond = nil,
	},
	treesitter = {
		function()
			local b = vim.api.nvim_get_current_buf()
			if next(vim.treesitter.highlighter.active[b]) then
				return ""
			end
			return ""
		end,
		color = { fg = colors.green },
		cond = conditions.hide_in_width,
	},
	lsp = {
		function(_)
			local buf_client_names = {}

			-- add LSP clients
			for _, client in ipairs(vim.lsp.get_active_clients()) do
				if client.attached_buffers[vim.api.nvim_win_get_buf(0)] and client.name ~= "null-ls" then
					table.insert(buf_client_names, client.name)
				end
			end

			-- add formatters
			for _, formatter in ipairs(require("conform").list_formatters(0)) do
				table.insert(buf_client_names, formatter.name)
			end

			-- add linters
			for _, linter in ipairs(require("lint").get_running()) do
				table.insert(buf_client_names, linter)
			end

			if #buf_client_names > 0 then
				return "[" .. table.concat(buf_client_names, ", ") .. "]"
			else
				return "LSP Inactive"
			end
		end,
		-- icon = "",
		color = { gui = "bold" },
		cond = conditions.hide_in_width,
	},
	location = { "location", cond = nil, color = {}, padding = 1 },
	progress = { "progress", cond = conditions.hide_in_width, color = {} },
	spaces = {
		function()
			if not vim.api.nvim_buf_get_option(0, "expandtab") then
				return "󰌒 " .. vim.api.nvim_buf_get_option(0, "tabstop")
			end
			local size = vim.api.nvim_buf_get_option(0, "shiftwidth")
			if size == 0 then
				size = vim.api.nvim_buf_get_option(0, "tabstop")
			end
			return " " .. size
		end,
		cond = nil,
		color = {},
	},
	encoding = {
		"o:encoding",
		fmt = string.upper,
		color = {},
		cond = conditions.hide_in_width,
	},
	filetype = { "filetype", cond = nil, color = {}, icon = { align = "left" } },
	scrollbar = {
		function()
			local current_line = vim.fn.line(".")
			local total_lines = vim.fn.line("$")
			local chars = { "__", "▁▁", "▂▂", "▃▃", "▄▄", "▅▅", "▆▆", "▇▇", "██" }
			local line_ratio = current_line / total_lines
			local index = math.ceil(line_ratio * #chars)
			return chars[index]
		end,
		padding = { left = 0, right = 0 },
		color = { fg = colors.yellow, bg = colors.bg },
		cond = nil,
	},
	fileformat = {
		"fileformat",
		icons_enabled = false,
	},
}
