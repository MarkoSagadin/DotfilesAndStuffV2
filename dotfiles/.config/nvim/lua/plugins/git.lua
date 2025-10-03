return {
	{
		"lewis6991/gitsigns.nvim",
		event = "User FilePost",
		opts = {
			signs = {
				add = { text = "▎" },
				change = { text = "▎" },
				delete = { text = "" },
				topdelete = { text = "" },
				changedelete = { text = "~" },
				untracked = { text = "┆" },
			},
			preview_config = {
				-- Options passed to nvim_open_win
				border = "rounded",
				style = "minimal",
				relative = "cursor",
				row = 0,
				col = 1,
			},
			on_attach = function(bufnr)
				local function map(mode, lhs, rhs, opts)
					opts = vim.tbl_extend("force", { noremap = true, silent = true }, opts or {})
					vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, opts)
				end

				-- Navigation
				map("n", "]c", "&diff ? ']c' : '<cmd>Gitsigns next_hunk<CR>'", { expr = true })
				map("n", "[c", "&diff ? '[c' : '<cmd>Gitsigns prev_hunk<CR>'", { expr = true })

				-- Actions
				map("n", "<leader>hs", ":Gitsigns stage_hunk<CR>")
				map("v", "<leader>hs", ":Gitsigns stage_hunk<CR>")
				map("n", "<leader>hr", ":Gitsigns reset_hunk<CR>")
				map("v", "<leader>hr", ":Gitsigns reset_hunk<CR>")
				map("n", "<leader>hS", ":Gitsigns stage_buffer<CR>")
				map("n", "<leader>hu", ":Gitsigns undo_stage_hunk<CR>")
				map("n", "<leader>hR", ":Gitsigns reset_buffer<CR>")
				map("n", "<leader>hp", ":Gitsigns preview_hunk<CR>")
				map("n", "<leader>hb", "<cmd>lua require\"gitsigns\".blame_line{full=true}<CR>")
				map("n", "<leader>hB", ":BlameToggle<CR>")
				map("n", "<leader>tb", ":Gitsigns toggle_current_line_blame<CR>")
				map("n", "<leader>hd", ":Gitsigns diffthis<CR>")
				map("n", "<leader>hD", "<cmd>lua require\"gitsigns\".diffthis(\"~\")<CR>")
				map("n", "<leader>td", ":Gitsigns toggle_deleted<CR>")

				-- Text object
				map("o", "ih", ":<C-U>Gitsigns select_hunk<CR>")
				map("x", "ih", ":<C-U>Gitsigns select_hunk<CR>")
			end,
		},
	},
	{
		"FabijanZulj/blame.nvim",
		cmd = { "BlameToggle" },
		opts = {
			-- I have generated below on https://rootloops.sh/
			colors = {
				"#ede0d6",
				"#d97780",
				"#7aa860",
				"#bc904f",
				"#6b9bd9",
				"#b77ed1",
				"#52a9a9",
				"#d0b39c",
				"#634c3a",
				"#e6949a",
				"#8ebf73",
				"#d3a563",
				"#88b1e5",
				"#c899de",
				"#63c0bf",
				"#f6efea",
			},
		},
	},
	{
		"NeogitOrg/neogit",
		dependencies = {
			"nvim-lua/plenary.nvim", -- required
			"sindrets/diffview.nvim", -- optional - Diff integration
			"nvim-telescope/telescope.nvim", -- optional
		},

		cmd = { "Neogit" },

		opts = {
			integrations = {
				telescope = true,
			},
			commit_editor = {
				staged_diff_split_kind = "vsplit",
			},

			initial_branch_name = "feature/",
			mappings = {
				commit_editor = {
					["q"] = "Close",
					["<c-e>"] = "Submit",
					["<c-q>"] = "Abort",
				},
				commit_editor_I = {
					["<c-e>"] = "Submit",
					["<c-q>"] = "Abort",
				},
				rebase_editor_I = {
					["<c-e>"] = "Submit",
					["<c-q>"] = "Abort",
				},
			},
		},
	},
}
