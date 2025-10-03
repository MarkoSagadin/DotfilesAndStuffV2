-----------------------
-- Keymaps
------------------------
local function keymap(mode, key, cmd, desc)
	desc = desc or ""
	local opts = { noremap = true, silent = true, desc = desc }

	vim.api.nvim_set_keymap(mode, key, cmd, opts)
end

-- jk is now escape
keymap("i", "jk", "<ESC>")

-- Remap space as leader key, but first unmap it from any other mode
keymap("", "<Space>", "<Nop>")
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Jumping in and out of tags
keymap("n", "<leader>i", "g<C-]>", "Jump in tag")
keymap("n", "<leader>o", "<C-t>", "Jump out of tag")

-- Better window navigation in normal mode
keymap("n", "<C-h>", "<C-w>h")
keymap("n", "<C-j>", "<C-w>j")
keymap("n", "<C-k>", "<C-w>k")
keymap("n", "<C-l>", "<C-w>l")

-- Resize with arrows
keymap("n", "<Up>", ":resize -2<cr>")
keymap("n", "<Down>", ":resize +2<cr>")
keymap("n", "<Left>", ":vertical resize +2<cr>")
keymap("n", "<Right>", ":vertical resize -2<cr>")

-- Open and close Nvim Tree
keymap("n", "<C-c>", ":NvimTreeToggle<cr>", "Toggle NvimTree")
keymap("n", "-", ":Oil<cr>", "Open parent directory")

-- Telescope mappings
keymap("n", "<C-p>", ":lua require('utils').project_files()<cr>", "Find files (Telescope)")
keymap("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", "Live grep (Telescope)")
keymap("n", "<leader><space>", "<cmd>Telescope buffers<cr>", "Find buffers (Telescope)")
keymap("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", "Help page (Telescope)")
keymap("n", "<leader>fd", "<cmd>Telescope current_buffer_fuzzy_find<cr>", "Grep in open buffer (Telescope)")

-- Harpoon mappings for file navigation
-- keymap("n", "<leader>a", ":lua require('harpoon.mark').add_file()<cr>", opts)
-- keymap("n", "<leader>e", ":lua require('harpoon.ui').toggle_quick_menu()<cr>", opts)
-- keymap("n", "<leader>j", ":lua require('harpoon.ui').nav_file(1)<cr>", opts)
-- keymap("n", "<leader>k", ":lua require('harpoon.ui').nav_file(2)<cr>", opts)
-- keymap("n", "<leader>;", ":lua require('harpoon.ui').nav_file(3)<CR>", opts)
--
-- -- Harpoon mappings for tmux execution
-- keymap("n", "<leader>w", ":lua require('harpoon.cmd-ui').toggle_quick_menu()<CR>", opts)
-- keymap("n", "<leader>1", ":lua require('harpoon.tmux').sendCommand('{right-of}', 1)<CR>", opts)
-- keymap("n", "<leader>2", ":lua require('harpoon.tmux').sendCommand('{right-of}', 2)<CR>", opts)

-- Documentation generation
keymap("n", "<leader>d", "<cmd>Neogen<CR>", "Generate docs (Neogen)")

-- Neogit mappings
keymap("n", "<C-s>", "<cmd>Neogit<CR>", "Git status (Neogit)")

-- Substitute plugin
keymap("n", "s", "<cmd>lua require('substitute').operator()<cr>", "Operator (Substitute)")
keymap("n", "ss", "<cmd>lua require('substitute').line()<cr>", "Line (Substitute)")
keymap("n", "S", "<cmd>lua require('substitute').eol()<cr>", "End of line (Substitute)")
keymap("x", "s", "<cmd>lua require('substitute').visual()<cr>", "Visual (Substitute)")

keymap("n", "<leader>s", "<cmd>lua require('substitute.range').operator()<cr>", "Range operator (Substitute)")
keymap("x", "<leader>s", "<cmd>lua require('substitute.range').visual()<cr>", "Visual range (Substitute)")
keymap("n", "<leader>ss", "<cmd>lua require('substitute.range').word()<cr>", "Word range (Substitute)")
keymap("n", "sx", "<cmd>lua require('substitute.exchange').operator()<cr>", "Exchange operator (Substitute)")
keymap("n", "sxx", "<cmd>lua require('substitute.exchange').line()<cr>", "Exchange line (Substitute)")
keymap("x", "X", "<cmd>lua require('substitute.exchange').visual()<cr>", "Exchange visual (Substitute)")

-- LSP keymaps
keymap("n", "<leader>c", "<Cmd>LspClangdSwitchSourceHeader<CR>", "Switch source/header (LSP)")

-- Diagnostics
keymap("n", "gl", "<cmd>lua vim.diagnostic.open_float()<cr>", "Line diagnostics (LSP)")
keymap("n", "]d", "<cmd>lua vim.diagnostic.goto_next({buffer=0})<cr>", "Go to next diagnostic (LSP)")
keymap("n", "[d", "<cmd>lua vim.diagnostic.goto_prev({buffer=0})<cr>", "Go to previous diagnostic (LSP)")
-- keymap("n", "<leader>lq", "<cmd>lua vim.diagnostic.setloclist()<cr>", "Diagnostic loclist (LSP)")

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
