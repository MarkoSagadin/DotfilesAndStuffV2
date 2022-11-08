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

-- Remap space as leader key, but first unmap it from any other mode
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- For refreshing neovim config
keymap("n", "<F5>", ":source $MYVIMRC<cr>", opts)

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
keymap("n", "<leader>fd", "<cmd>Telescope current_buffer_fuzzy_find<cr>", opts)

-- Trouble mappings
keymap("n", "<leader>xx", "<cmd>Trouble<cr>", opts)
keymap("n", "<leader>xw", "<cmd>Trouble workspace_diagnostics<cr>", opts)
keymap("n", "<leader>xd", "<cmd>Trouble document_diagnostics<cr>", opts)
keymap("n", "<leader>xl", "<cmd>Trouble loclist<cr>", opts)
keymap("n", "<leader>xq", "<cmd>Trouble quickfix<cr>", opts)
keymap("n", "gR", "<cmd>Trouble lsp_references<cr>", opts)

-- Harpoon mappings for file navigation
keymap("n", "<leader>a", ":lua require('harpoon.mark').add_file()<CR>", opts)
keymap("n", "<leader>e", ":lua require('harpoon.ui').toggle_quick_menu()<CR>", opts)
keymap("n", "<leader>j", ":lua require('harpoon.ui').nav_file(1)<CR>", opts)
keymap("n", "<leader>k", ":lua require('harpoon.ui').nav_file(2)<CR>", opts)
keymap("n", "<leader>;", ":lua require('harpoon.ui').nav_file(3)<CR>", opts)

-- Harpoon mappings for tmux execution
keymap("n", "<leader>w", ":lua require('harpoon.cmd-ui').toggle_quick_menu()<CR>", opts)
keymap("n", "<leader>1", ":lua require('harpoon.tmux').sendCommand('{right-of}', 1)<CR>", opts)
keymap("n", "<leader>2", ":lua require('harpoon.tmux').sendCommand('{right-of}', 2)<CR>", opts)

-- Documentation generation
keymap("n", "<leader>d", "<cmd>Neogen<CR>", opts)

-- Comments
keymap("n", "<leader>ll", "<cmd>CommentToggle<CR>", opts)
keymap("v", "<leader>l", ":CommentToggle<cr>", opts)

-- Substitute plugin
keymap("n", "s", "<cmd>lua require('substitute').operator()<cr>", opts)
keymap("n", "ss", "<cmd>lua require('substitute').line()<cr>", opts)
keymap("n", "S", "<cmd>lua require('substitute').eol()<cr>", opts)
keymap("x", "s", "<cmd>lua require('substitute').visual()<cr>", opts)
keymap("n", "<leader>s", "<cmd>lua require('substitute.range').operator()<cr>", opts)
keymap("x", "<leader>s", "<cmd>lua require('substitute.range').visual()<cr>", opts)
keymap("n", "<leader>ss", "<cmd>lua require('substitute.range').word()<cr>", opts)
keymap("n", "sx", "<cmd>lua require('substitute.exchange').operator()<cr>", opts)
keymap("n", "sxx", "<cmd>lua require('substitute.exchange').line()<cr>", opts)
keymap("x", "X", "<cmd>lua require('substitute.exchange').visual()<cr>", opts)
keymap("n", "sxc", "<cmd>lua require('substitute.exchange').cancel()<cr>", opts)

-- Diagnostics - they are needed here so they can be also used for null-ls,
-- not only lspconfig
keymap("n", "gl", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
keymap("n", "<leader>lj", "<cmd>lua vim.diagnostic.goto_next({buffer=0})<cr>", opts)
keymap("n", "<leader>lk", "<cmd>lua vim.diagnostic.goto_prev({buffer=0})<cr>", opts)
keymap("n", "<leader>lq", "<cmd>lua vim.diagnostic.setloclist()<cr>", opts)

-- keymap("n", "<F5>", ":Termdebug --iex='app/build/nrf52832_xxaa' <CR>", opts)
--
-- keymap("n", "<F5>", " <Cmd>lua require'dap'.continue()<CR>", opts)
-- keymap("n", "<F10>", "<Cmd>lua require'dap'.step_over()<CR>", opts)
-- keymap("n", "<F11>", "<Cmd>lua require'dap'.step_into()<CR>", opts)
-- keymap("n", "<F12>", "<Cmd>lua require'dap'.step_out()<CR>", opts)
-- keymap("n", "<Leader>b", "<Cmd>lua require'dap'.toggle_breakpoint()<CR>", opts)
-- keymap("n", "<Leader>B", "<Cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>", opts)
-- keymap(
-- 	"n",
-- 	"<Leader>lp",
-- 	"<Cmd>lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>",
-- 	opts
-- )
-- keymap("n", "<Leader>dr", "<Cmd>lua require'dap'.repl.open()<CR>", opts)
-- keymap("n", "<Leader>dl", "<Cmd>lua require'dap'.run_last()<CR>", opts)

-- Reload snippets
keymap("n", "<leader>m", "<cmd>source ~/.config/nvim/lua/user/snippets.lua<CR>", opts)
