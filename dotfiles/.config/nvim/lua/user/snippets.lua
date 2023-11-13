local status_ok, ls = pcall(require, "luasnip")
if not status_ok then
	return
end
local status_ok_extra, ls_extra = pcall(require, "luasnip.extras")
if not status_ok_extra then
	return
end

-- some shorthands...
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local parse = ls.parser.parse_snippet
local l = ls_extra.lambda
local rep = ls_extra.rep
local p = ls_extra.partial
local m = ls_extra.match
local n = ls_extra.nonempty
local dl = ls_extra.dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local types = require("luasnip.util.types")
local conds = require("luasnip.extras.expand_conditions")

-- Every unspecified option will be set to the default.
ls.config.set_config({
	history = true,
	-- Update more often, :h events for more info.
	update_events = "TextChanged,TextChangedI",
	ext_opts = {
		[types.choiceNode] = {
			active = {
				virt_text = { { "choiceNode", "Comment" } },
			},
		},
	},
	-- treesitter-hl has 100, use something higher (default is 200).
	ext_base_prio = 300,
	-- minimal increase in priority.
	ext_prio_increase = 1,
	enable_autosnippets = true,
})

-- args is a table, where 1 is the text in Placeholder 1, 2 the text in
-- placeholder 2,...
local function copy(args)
	return args[1]
end

-- Make sure to not pass an invalid command, as io.popen() may write over nvim-text.
local function bash(_, _, command)
	local file = io.popen(command, "r")
	local res = {}
	for line in file:lines() do
		table.insert(res, line)
	end
	return res
end
-- Returns a snippet_node wrapped around an insert_node whose initial
-- text value is set to the current date in the desired format.
local date_input = function(_, _, fmt)
	local fmt = fmt or "%Y-%m-%d"
	return os.date(fmt)
end

-- in a lua file: search lua-snippets, then c then all-snippets .
ls.filetype_extend("lua", { "c" })
-- in a cpp file: search cpp-snippets, then c then all-snippets .
ls.filetype_extend("cpp", { "c" })

local same = function(index)
	return f(function(arg)
		return arg[1]
	end, { index })
end

local get_filename = function()
	local full_path = vim.api.nvim_buf_get_name(0)
	local names = vim.split(full_path, "/", { plain = true })
	local name = vim.split(names[#names], ".", { plain = true })
	return name[1]
end

local get_headername = function()
	local filename = get_filename()
	-- Use % to escape the dot, second argument of gsub is _patter_
	return string.upper(string.gsub(filename, "%.", "_"))
end

ls.add_snippets(nil, {
	-- 	-- When trying to expand a snippet, luasnip first searches the tables for
	-- 	-- each filetype specified in 'filetype' followed by 'all'.
	-- 	-- If ie. the filetype is 'lua.c'
	-- 	--     - luasnip.lua
	-- 	--     - luasnip.c
	-- 	--     - luasnip.all
	-- 	-- are searched in that order.

	c = {
		-- trigger is fn.
		parse("com", "/* $1 */"),
		s(
			"emptyc",
			fmta(
				[[
/** @file <>.c
 *
 * @brief
 *
 * @par
 * COPYRIGHT NOTICE: (c) <> Irnas. All rights reserved.
 */

#include "<>.h"
]],
				{
					f(get_filename),
					f(date_input, {}, { user_args = { "%Y" } }),
					f(get_filename),
				}
			)
		),

		s(
			"emptyh",
			fmta(
				[[
/** @file <>.h
 *
 * @brief 
 *
 * @par
 * COPYRIGHT NOTICE: (c) <> Irnas. All rights reserved.
 */

#ifndef <>_H
#define <>_H

#ifdef __cplusplus
extern "C" {
#endif

#ifdef __cplusplus
}
#endif

#endif /* <>_H */
	]],
				{
					f(get_filename),
					f(date_input, {}, { user_args = { "%Y" } }),
					f(get_headername),
					f(get_headername),
					f(get_headername),
				}
			)
		),
	},
})

-- autotriggered snippets have to be defined in a separate table, luasnip.autosnippets.
ls.autosnippets = {
	all = {
		s("autotrigger", {
			t("autosnippet"),
		}),
	},
}
