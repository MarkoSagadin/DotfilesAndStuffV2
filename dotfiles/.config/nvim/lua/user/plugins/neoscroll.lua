local status_ok, neoscroll = pcall(require, "neoscroll")
if not status_ok then
	return
end

neoscroll.setup({
	easing_function = "sine", -- Default easing function
})

local t = {}
t["<C-a>"] = { "scroll", { "-vim.wo.scroll", "true", "350" } }
t["<C-d>"] = { "scroll", { "vim.wo.scroll", "true", "350" } }
t["zt"] = { "zt", { "300" } }
t["zz"] = { "zz", { "300" } }
t["zb"] = { "zb", { "300" } }

-- For some reason it throws me an error, if require is not used.
require("neoscroll.config").set_mappings(t)
