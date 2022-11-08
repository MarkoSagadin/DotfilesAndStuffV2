local status_ok, _ = pcall(require, "lspconfig")
if not status_ok then
	return
end

-- This file should be only lazy loaded cause of nvim-lspconfig, so it can
-- attach the lsp servers to the nvim.
-- Mason needs to be setup before it, as the lspconfig needs it.
require("user.lsp.mason").setup()
-- require("user.lsp.null-ls")

require("user.lsp.handlers").setup()
require("user.lsp.register-settings")
