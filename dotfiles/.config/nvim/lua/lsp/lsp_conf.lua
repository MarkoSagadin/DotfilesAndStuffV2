------------------------
-- LSP Configuration
------------------------
-- LSP keymaps and Highlight settings
M = {}

local function keymap(bufnr, mode, key, cmd, desc)
	desc = desc or ""
	local opts = { noremap = true, silent = true, desc = desc }

	vim.api.nvim_buf_set_keymap(bufnr, mode, key, cmd, opts)
end

-- This function defines keymaps for lsp functionalities
M.lsp_keymaps = function(bufnr)
	local opts = { noremap = true, silent = true }
	keymap(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", "GoTo declaration (LSP)")
	keymap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", "GoTo definition (LSP)")
	keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", "Hover (LSP)")
	keymap(bufnr, "n", "gI", "<cmd>lua vim.lsp.buf.implementation()<cr>", "Show implementations (LSP)")
	keymap(bufnr, "n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", "Show references (LSP)")

	vim.diagnostic.open_floatkeymap(bufnr, "n", "<leader>lf", "<cmd>lua vim.lsp.buf.format{ async = true }<cr>", opts)
	keymap(bufnr, "n", "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<cr>", "Code action (LSP)")
	keymap(bufnr, "n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<cr>", "Rename symbol (LSP)")
	keymap(bufnr, "n", "<leader>ls", "<cmd>lua vim.lsp.buf.signature_help()<cr>", "Signature help (LSP)")
end

-- This function will check if the given lsp client supports highlighting.
-- If it does it will enable it.
M.lsp_highlight_document = function(client, bufnr)
	if client.server_capabilities.documentHighlightProvider then
		vim.api.nvim_create_augroup("lsp_document_highlight", { clear = true })
		vim.api.nvim_clear_autocmds({ buffer = bufnr, group = "lsp_document_highlight" })
		vim.api.nvim_create_autocmd("CursorHold", {
			callback = vim.lsp.buf.document_highlight,
			buffer = bufnr,
			group = "lsp_document_highlight",
			desc = "Document Highlight",
		})
		vim.api.nvim_create_autocmd("CursorMoved", {
			callback = vim.lsp.buf.clear_references,
			buffer = bufnr,
			group = "lsp_document_highlight",
			desc = "Clear All the References",
		})
	end
end

return M
