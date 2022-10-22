local lspconfig_status_ok, lspconfig = pcall(require, "lspconfig")
if not lspconfig_status_ok then
	return
end

local servers = require("user.lsp.mason").lsp_servers
local handlers = require("user.lsp.handlers")

local keymap = vim.api.nvim_set_keymap
local k_opts = { noremap = true, silent = true }

for _, server in pairs(servers) do
	local opts = {
		on_attach = nil,
		capabilities = require("user.lsp.handlers").capabilities,
	}

	local require_ok, server_specific_opts = pcall(require, "user.lsp.settings." .. server)
	if require_ok then
		opts = vim.tbl_deep_extend("force", server_specific_opts, opts)
	end

	opts.on_attach = function(client, bufnr)
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

		-- -- Specific to clangd
	end

	lspconfig[server].setup(opts)
end
