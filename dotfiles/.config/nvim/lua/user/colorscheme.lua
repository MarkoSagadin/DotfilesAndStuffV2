local colorscheme = "tokyonight"

-- Do protected call so nothing fails on the first run
local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
if not status_ok then
	return
end

local status_ok_tr, transparent = pcall(require, "transparent")
if not status_ok_tr then
	return
end

transparent.setup({
	enable = false, -- boolean: enable transparent
})
