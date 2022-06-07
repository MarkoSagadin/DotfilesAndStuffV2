return {
	settings = {
		Lua = {
			diagnostics = {
				globals = { "vim" },
			},
			workspace = {
				library = {
					[vim.fn.expand("$VIMRUNTIME/lua")] = true,
					[vim.fn.stdpath("config") .. "/lua"] = true,
				},
			},
		},
	},
}

-- local status_ok, lua_dev = pcall(require, "lua-dev")
-- if not status_ok then
-- 	return
-- end
-- opts = lua_dev.setup({ lspconfig = opts }),
