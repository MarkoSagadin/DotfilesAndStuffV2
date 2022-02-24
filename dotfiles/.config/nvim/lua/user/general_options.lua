------------------------
-- General options
------------------------

-- Construct a table, where keys are on the left, values are on the right
local options = {
	tabstop = 4, -- Number of visual spaces per TAB
	softtabstop = 4, -- Number of spaces in tab when editing
	shiftwidth = 4, -- The number of spaces inserted for each indentation
	expandtab = true, -- Convert tabs to spaces
	number = true, -- Set numbered lines
	cursorline = true, -- Highlight current line
	colorcolumn = "80", -- Highlight specified column for line wrapin
	wildmenu = true, -- Visual autocomplete for command menu
	showmatch = true, -- Highlight bracket matching
	fileformat = "unix", -- LF endings
	splitright = true, -- New vertical splits are opened to the right
	splitbelow = true, -- New horizontal splits are opened below
	wrap = true, -- Wrap long lines
	linebreak = true, -- Do not break words in the middle
	hlsearch = false, -- dont highlight all matches on previous search pattern
	ignorecase = true, -- Ignore case when searching...
	smartcase = true, -- ...unless we type a capital letter
	scrolloff = 5, -- Cursor won't go to the end of the screen when scrolling
	updatetime = 100, -- faster completion
	numberwidth = 4, -- set number column width to 2 {default 4}
	timeoutlen = 1000, -- Set which key menu to appear after 1 second
	termguicolors = true, -- Needed for proper coloring
	inccommand = "nosplit",
	signcolumn = "yes", -- Always show signcolumn for gitsigns
}

-- Pairs returns key-value pair from table `options` in no particular order
-- and fills up vim.opt table with them.
for k, v in pairs(options) do
	vim.opt[k] = v
end

-- Some options need to be appended or removed, this has to be done separately
vim.opt.clipboard:prepend("unnamed,unnamedplus")

-- Used to tell where tags are located
vim.cmd([[set tags+=~/work/nrf5_sdk/tags]])
vim.cmd([[set tags+=~/Work/nrf5_sdk/tags]])
vim.cmd([[set tags+=$ZEPHYR_BASE/tags]])

-- Autocommands
vim.cmd([[
au BufNewFile,BufRead [Dd]ockerfile* setf dockerfile
au BufNewFile,BufRead /*.rasi setf css
augroup open_help_vertical
  autocmd!
  autocmd BufEnter *.txt if &buftype == 'help' | wincmd L | endif
augroup END
]])
