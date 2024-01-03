local status_ok_tn, tokyonight = pcall(require, "tokyonight")
if not status_ok_tn then
	return
end

	local colorscheme = "tokyonight"
    vim.cmd(":hi LineNr guibg=None guifg=#565f89")
	-- Needs to run before colorscheme cmd
	tokyonight.setup({
		-- transparent = true, -- Enable this to disable setting the background color
		-- styles = {
		-- 	sidebars = "transparent",
		-- 	floats = "transparent",
		-- },
	})
	-- Do protected call so nothing fails on the first run
	local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
	if not status_ok then
		return
	end

-- if os.getenv("THEME") == "light" then
-- 	local colorscheme = "tokyonight-day"
-- 	-- Needs to run before colorscheme cmd
-- 	tokyonight.setup({})
-- 	-- Do protected call so nothing fails on the first run
-- 	local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
-- 	if not status_ok then
-- 		return
-- 	end
-- else
-- 	local colorscheme = "tokyonight"
-- 	-- Needs to run before colorscheme cmd
-- 	tokyonight.setup({
-- 		transparent = true, -- Enable this to disable setting the background color
-- 		styles = {
-- 			sidebars = "transparent",
-- 			floats = "transparent",
-- 		},
-- 	})
-- 	-- Do protected call so nothing fails on the first run
-- 	local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
-- 	if not status_ok then
-- 		return
-- 	end
-- 
-- 	-- Override the line number,as with tokyonight is a bit too dim when uisng
-- 	-- transparent terminal.
-- 	vim.cmd(":hi LineNr guibg=None guifg=#565f89")
-- 
-- 	local status_ok_tr, transparent = pcall(require, "transparent")
-- 	if not status_ok_tr then
-- 		return
-- 	end
-- 
-- 	transparent.setup({})
-- end
