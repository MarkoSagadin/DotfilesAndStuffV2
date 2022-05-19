------------------------------------
-- General options for Python files
------------------------------------

-- Construct a table, where keys are on the left, values are on the right
local options = {
	colorcolumn = "100", -- Highlight specified column for line wrapin
}

-- Pairs returns key-value pair from table `options` in no particular order
-- and fills up vim.opt table with them.
for k, v in pairs(options) do
	vim.opt[k] = v
end
