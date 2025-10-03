-- Find more schemas here: https://www.schemastore.org/json/
local schemas = {
	["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
}

return {
	settings = {
		yaml = {
			schemas = schemas,
		},
	},
	setup = {
		commands = {
			Format = {
				function()
					vim.lsp.buf.range_formatting({}, { 0, 0 }, { vim.fn.line("$"), 0 })
				end,
			},
		},
	},
}
