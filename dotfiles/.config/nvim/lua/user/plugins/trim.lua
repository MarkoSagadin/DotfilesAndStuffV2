local status_ok, trim = pcall(require, "trim")
if not status_ok then
	return
end

-- trim.setup({
-- 	patterns = {
-- 		[[%s/\s\+$//e]], -- Trim away just trailing whitespace
-- 	},
-- })
