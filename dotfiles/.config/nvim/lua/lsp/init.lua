------------------------
-- LSP
------------------------

---------------------------
-- Diagnostic Configuration
---------------------------
local config = {
	-- disable virtual text
	virtual_text = false,
	-- show signs
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "",
			[vim.diagnostic.severity.WARN] = "",
			[vim.diagnostic.severity.HINT] = "",
			[vim.diagnostic.severity.INFO] = "",
		},
	},
	update_in_insert = true,
	underline = true,
	severity_sort = true,
	float = {
		focusable = false,
		style = "minimal",
		border = "rounded",
		source = "always",
		header = "",
		prefix = "",
	},
}

vim.diagnostic.config(config)

------------------------
-- LSP keymaps
------------------------
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(event)
		local bufmap = function(mode, rhs, lhs)
			vim.keymap.set(mode, rhs, lhs, { buffer = event.buf })
		end

		-- These are custom keymaps
		bufmap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>")
		bufmap("n", "grt", "<cmd>lua vim.lsp.buf.type_definition()<cr>")
		bufmap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>")
		bufmap({ "n", "x" }, "gq", "<cmd>lua vim.lsp.buf.format({async = true})<cr>")
	end,
})

------------------------
-- LSP fancy things
------------------------
vim.api.nvim_create_autocmd("LspAttach", {
	desc = "Setup highlight symbol",
	callback = function(event)
		local id = vim.tbl_get(event, "data", "client_id")
		local client = id and vim.lsp.get_client_by_id(id)

		if client == nil or not client.supports_method("textDocument/documentHighlight") then
			return
		end

		local group = vim.api.nvim_create_augroup("highlight_symbol", { clear = false })

		vim.api.nvim_clear_autocmds({ buffer = event.buf, group = group })

		vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
			group = group,
			buffer = event.buf,
			callback = vim.lsp.buf.document_highlight,
		})

		vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
			group = group,
			buffer = event.buf,
			callback = vim.lsp.buf.clear_references,
		})
	end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
	desc = "Organize imports and format on save",
	pattern = { "*.py" },
	callback = function()
		vim.lsp.buf.code_action({
			---@diagnostic disable-next-line: missing-fields
			context = { only = { "source.organizeImports" } },
			apply = true,
		})
		vim.lsp.buf.format({ async = false })
		vim.cmd("w")
	end,
})

------------------------
-- LSP final configure
------------------------
local capabilities = vim.lsp.protocol.make_client_capabilities()
vim.lsp.config("*", {
	capabilities = require("blink.cmp").get_lsp_capabilities(capabilities),
})
