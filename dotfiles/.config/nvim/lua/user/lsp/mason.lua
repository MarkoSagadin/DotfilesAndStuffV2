local mason_status_ok, mason = pcall(require, "mason")
if not mason_status_ok then
	return
end
local mason_null_ls_status_ok, mason_null_ls = pcall(require, "mason-null-ls")
if not mason_null_ls_status_ok then
	return
end

local mason_lspconfig_status_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
if not mason_lspconfig_status_ok then
	return
end
local M = {}

-- List the formatters, diagnostics, linters you want to have
-- installed by default
local null_ls_tools = {
	"isort",
	"black",
	"stylua",
	"clang_format",
	"fixjson",
	"shfmt",
	"cmake_format",
	"flake8",
	"luacheck",
	"vale",
	"rustfmt",
	"hadolint",
	"markdownlint",
	"prettierd",
}

-- List the lsp servers you want to have installed by default
M.lsp_servers = {
	"bashls",
	"pyright",
	"jsonls",
	"yamlls",
	"clangd",
	"cmake",
	"sumneko_lua",
}
M.setup = function()
	mason.setup({
		PATH = "prepend", -- "skip" seems to cause the spawning error
	})
	mason_null_ls.setup({
		ensure_installed = null_ls_tools,
		automatic_installation = true,
	})
	mason_lspconfig.setup({
		ensure_installed = M.lsp_servers,
		automatic_installation = true,
	})
end

return M
