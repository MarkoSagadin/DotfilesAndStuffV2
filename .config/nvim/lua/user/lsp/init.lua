local status_ok, _ = pcall(require, "lspconfig")
if not status_ok then
	return
end

local status_ok, lsp_installer = pcall(require, "nvim-lsp-installer")
if not status_ok then
	return
end

-- Include the servers you want to have installed by default below
local servers = {
	"bashls",
	"pyright",
	"jsonls",
	"yamlls",
	"clangd",
	"cmake",
	"sumneko_lua",
}

-- This chunk will install each server
for _, name in pairs(servers) do
	local server_is_found, server = lsp_installer.get_server(name)
	if server_is_found then
		if not server:is_installed() then
			print("Installing " .. name)
			server:install()
		end
	end
end

require("user.lsp.register-settings")
require("user.lsp.handlers").setup()
