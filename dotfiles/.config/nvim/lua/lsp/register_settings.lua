------------------------
-- Register LSP settings
------------------------
local lsp_conf = require("lsp.lsp_conf")

local keymap = vim.api.nvim_set_keymap
local k_opts = { noremap = true, silent = true }

-- Prepares object which represents client capabilites
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

-- TODO: figure out what to do with this
-- Specifically add cmp-nvim-lsp before loading it, as it is lazy loaded.
--vim.api.nvim_command([[packadd cmp-nvim-lsp]])

local default_opts = {
	on_attach = function(client, bufnr)
		lsp_conf.lsp_highlight_document(client)
		lsp_conf.lsp_keymaps(bufnr)

		if client.name == "clangd" then
			client.server_capabilities.documentFormattingProvider = false
			keymap("n", "<leader>c", "<Cmd>ClangdSwitchSourceHeader<CR>", k_opts)
		end
		if client.name == "lua_ls" then
			client.server_capabilities.documentFormattingProvider = false
		end
		if client.name == "jsonls" then
			client.server_capabilities.documentFormattingProvider = false
		end
	end,
	capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities),
}

local setup_opts = {
	-- The first entry (without a key) will be the default handler
	-- and will be called for each installed server that doesn't have
	-- a dedicated handler.
	function(server_name)
		local opts = default_opts
		local require_ok, server_specific_opts = pcall(require, "user.lsp.settings." .. server_name)
		if require_ok then
			opts = vim.tbl_deep_extend("force", server_specific_opts, opts)
		end

		require("lspconfig")[server_name].setup(opts)
	end,
}

require("mason-lspconfig").setup_handlers(setup_opts)
