------------------------
-- Keymaps
------------------------

-- Shorten commonly used settings for keymaps
local opts = { noremap = true, silent = true }
local reopts = { noremap = false, silent = true }

-- Shorten function name
local keymap = vim.api.nvim_set_keymap

-- Maps

-- jk is now escape
keymap("i", "jk", "<ESC>", opts)

--Remap space as leader key, but first unmap it from any other mode
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Jumping in and out of tags
keymap("n", "<leader>i", "g<C-]>", opts)
keymap("n", "<leader>o", "<C-t>", opts)

-- Better window navigation in normal mode
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

-- Resize with arrows
keymap("n", "<Up>", ":resize -2<CR>", opts)
keymap("n", "<Down>", ":resize +2<CR>", opts)
keymap("n", "<Left>", ":vertical resize +2<CR>", opts)
keymap("n", "<Right>", ":vertical resize -2<CR>", opts)

-- Navigate buffers
keymap("n", "<S-h>", ":bprevious<CR>", opts)
keymap("n", "gb", ":ls<CR>:b<Space>", opts)

-- Open and close Nvim Tree
keymap("n", "<C-c>", ":NvimTreeToggle<CR>", opts)

-- Change and paste in one go
keymap("n", "s", "<plug>(SubversiveSubstitute)", reopts)
keymap("n", "ss", "<plug>(SubversiveSubstituteLine)", reopts)
keymap("n", "S", "<plug>(SubversiveSubstituteToEndOfLine)", reopts)
keymap("n", "<Leader>s", "<plug>(SubversiveSubstituteRange)", reopts)
keymap("x", "<Leader>ss", "<plug>(SubversiveSubstituteRange)", reopts)
keymap("n", "<Leader>S", "<plug>(SubversiveSubstituteWordRange)", reopts)

-- Telescope mappings
keymap("n", "<C-p>", "<cmd>Telescope git_files<cr>", opts)
keymap("n", "<leader>ff", "<cmd>Telescope find_files<cr>", opts)
keymap("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", opts)
keymap("n", "<leader><space>", "<cmd>Telescope buffers<cr>", opts)
keymap("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", opts)

-- Trouble mappings
keymap("n", "<leader>xx", "<cmd>Trouble<cr>", opts)
keymap("n", "<leader>xw", "<cmd>Trouble workspace_diagnostics<cr>", opts)
keymap("n", "<leader>xd", "<cmd>Trouble document_diagnostics<cr>", opts)
keymap("n", "<leader>xl", "<cmd>Trouble loclist<cr>", opts)
keymap("n", "<leader>xq", "<cmd>Trouble quickfix<cr>", opts)
keymap("n", "gR", "<cmd>Trouble lsp_references<cr>", opts)

-- Harpoon mappings
keymap("n", "<leader>a", ":lua require('harpoon.mark').add_file()<CR>", opts)
keymap("n", "<leader>e", ":lua require('harpoon.ui').toggle_quick_menu()<CR>", opts)

keymap("n", "<leader>j", ":lua require('harpoon.ui').nav_file(1)<CR>", opts)
keymap("n", "<leader>k", ":lua require('harpoon.ui').nav_file(2)<CR>", opts)
keymap("n", "<leader>;", ":lua require('harpoon.ui').nav_file(3)<CR>", opts)

-- LSP servers mappings
keymap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
keymap("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
keymap("n", "gl", ":lua vim.diagnostic.open_float(0, { border = \"rounded\" })<CR>", opts)
keymap("n", "[d", "<cmd>lua vim.diagnostic.goto_prev({ border = \"rounded\" })<CR>", opts)
keymap("n", "]d", "<cmd>lua vim.diagnostic.goto_next({ border = \"rounded\" })<CR>", opts)
keymap("n", "<leader>q", "<cmd>lua vim.diagnostic.setloclist()<CR>", opts)
-- -- Specific to clangd
keymap("n", "<leader>c", "<Cmd>ClangdSwitchSourceHeader<CR>", opts)

-- Documentation generation
keymap("n", "<leader>d", "<cmd>Neogen<CR>", opts)
