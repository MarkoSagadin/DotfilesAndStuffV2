------------------------
-- General options
------------------------

local opt = vim.opt

opt.tabstop = 4 -- Number of visual spaces per TAB
opt.softtabstop = 4 -- Number of spaces in tab when editing
opt.shiftwidth = 4 -- The number of spaces inserted for each indentation
opt.expandtab = true -- Convert tabs to spaces
opt.number = true -- Set numbered lines
opt.cursorline = true -- Highlight current line
opt.colorcolumn = "80" -- Highlight specified column for line wrapin
opt.wildmenu = true -- Visual autocomplete for command menu
opt.showmatch = true -- Highlight bracket matching
opt.fileformat = "unix" -- LF endings
opt.splitright = true -- New vertical splits are opened to the right
opt.splitbelow = true -- New horizontal splits are opened below
opt.wrap = true -- Wrap long lines
opt.linebreak = true -- Do not break words in the middle
opt.hlsearch = false -- Don't highlight all matches on previous search pattern
opt.ignorecase = true -- Ignore case when searching...
opt.smartcase = true -- ...unless we type a capital letter
opt.scrolloff = 5 -- Cursor won't go to the end of the screen when scrolling
opt.updatetime = 250 -- Interval for writing swap file to disk, used by gitsigns
opt.numberwidth = 4 -- Set number column width to 2 {default 4}
opt.timeoutlen = 500 -- Set which key menu to appear after 500 ms
opt.timeout = true
opt.termguicolors = true -- Needed for proper coloring
opt.signcolumn = "yes" -- Always show signcolumn for gitsigns
opt.pumheight = 20 -- Limit the number of times show in popup menu
opt.undofile = true -- Save undo history for files
opt.termguicolors = true -- Enable 24-bit colors
opt.inccommand = "nosplit"
opt.clipboard = "unnamedplus" -- Enable copying to system clipboard

-- Disable some default providers to decrease boot-up time.
for _, provider in ipairs({ "node", "perl", "python3", "ruby" }) do
	vim.g["loaded_" .. provider .. "_provider"] = 0
end
