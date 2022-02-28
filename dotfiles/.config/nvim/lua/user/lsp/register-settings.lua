local status_ok, lsp_installer = pcall(require, "nvim-lsp-installer")
if not status_ok then
	return
end

local function lsp_highlight_document(client)
	-- Set autocommands conditional on server_capabilities
	if client.resolved_capabilities.document_highlight then
		vim.api.nvim_exec(
			[[
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]],
			false
		)
	end
end

-- Register a handler that will be called for all installed servers.
-- Alternatively, you may also register handlers on specific server instances instead (see example below).
lsp_installer.on_server_ready(function(server)
	local opts = {
		on_attach = nil,
		capabilities = require("user.lsp.handlers").capabilities,
	}

	-- Import specific server settings if they exist, and then extend the
	-- default ops.
	local specific_settings_exists, server_specific_opts = pcall(require, "user.lsp.settings." .. server.name)

	if specific_settings_exists then
		opts = vim.tbl_deep_extend("force", server_specific_opts, opts)
	end

	-- Construct on attach cb, some clients require extra things here
	opts.on_attach = function(client, _)
		lsp_highlight_document(client)

		if client.name == "clangd" then
			client.resolved_capabilities.document_formatting = false
		end
		if client.name == "sumneko_lua" then
			client.resolved_capabilities.document_formatting = false
		end
		if client.name == "jsonls" then
			client.resolved_capabilities.document_formatting = false
		end
	end

	-- This setup() function is exactly the same as lspconfig's setup function.
	-- Refer to https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
	server:setup(opts)
end)
