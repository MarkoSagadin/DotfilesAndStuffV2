local status_ok, wk = pcall(require, "which-key")
if not status_ok then
	return
end

wk.setup({
	plugins = {
		spelling = {
			enabled = true,
		},
	},
	window = {
		border = "double", -- none, single, double, shadow
		position = "bottom", -- bottom, top
		margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
		padding = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom, left]
		winblend = 0,
	},
})
