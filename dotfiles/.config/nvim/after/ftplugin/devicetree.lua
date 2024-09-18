---------------------------------------
-- General options for devicetree files
---------------------------------------

-- Construct a table, where keys are on the left, values are on the right
local options = {
	tabstop = 4, -- Number of visual spaces per TAB
	softtabstop = 4, -- Number of spaces in tab when editing
	shiftwidth = 4, -- The number of spaces inserted for each indentation
	expandtab = false, -- Convert tabs to spaces
	colorcolumn = "80", -- Highlight specified column for line wrapin
	textwidth = 80,
}

-- Pairs returns key-value pair from table `options` in no particular order
-- and fills up vim.opt table with them.
for k, v in pairs(options) do
	vim.opt[k] = v
end
