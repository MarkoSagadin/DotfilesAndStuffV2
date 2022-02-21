-- require("colorbuddy").colorscheme("snazzybuddy")

local colorscheme = "dracula"

-- Uncomment below line, when using gruvbox to specify which gruvbox theme you
-- want
vim.o.background = "light"

local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
if not status_ok then
	vim.notify("Colorscheme " .. colorscheme .. " not found!")
	return
end

local status_ok_tr, transparent = pcall(require, "transparent")
if not status_ok_tr then
	return
end
transparent.setup({
	enable = true, -- boolean: enable transparent
})
