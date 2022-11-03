local handlers = require("user.lsp.handlers")

local keymap = vim.api.nvim_set_keymap
local k_opts = { noremap = true, silent = true }

local default_opts = {
	on_attach = function(client, bufnr)
		handlers.lsp_highlight_document(client)
		handlers.lsp_keymaps(bufnr)

		if client.name == "clangd" then
			client.server_capabilities.documentFormattingProvider = false
			keymap("n", "<leader>c", "<Cmd>ClangdSwitchSourceHeader<CR>", k_opts)
		end
		if client.name == "sumneko_lua" then
			client.server_capabilities.documentFormattingProvider = false
		end
		if client.name == "jsonls" then
			client.server_capabilities.documentFormattingProvider = false
		end
	end,
	capabilities = require("user.lsp.handlers").capabilities,
}

local setup_opts = {
	-- The first entry (without a key) will be the default handler
	-- and will be called for each installed server that doesn't have
	-- a dedicated handler.
	function(server_name)
		local opts = {}
		local require_ok, server_specific_opts = pcall(require, "user.lsp.settings." .. server_name)
		if require_ok then
			opts = vim.tbl_deep_extend("force", server_specific_opts, default_opts)
		end
		require("lspconfig")[server_name].setup(opts)
	end,
}

require("mason-lspconfig").setup_handlers(setup_opts)
