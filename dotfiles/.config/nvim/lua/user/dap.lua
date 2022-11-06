-- local dap = require("dap")
-- local dapui = require("dapui")

-- dap.adapters.cortex_debug = {
-- 	type = "executable",
-- 	command = "node",
-- 	args = { "/home/skobec/Programs/cortex_debug/extension/dist/debugadapter.js" },
-- }

-- dap.configurations.cortex_debug = {
-- 	{
-- 		type = "cortex_debug",
-- 		request = "launch",
-- 		servertype = "jlink",
-- 		serverpath = "/usr/bin/JLinkGDBServerCLExe",
-- 		cwd = vim.fn.getcwd(),
-- 		executable = "app/build/nrf52832_xxaa.out",
-- 		gdbPath = "/home/skobec/miniconda3/envs/apt/bin/arm-none-eabi-gdb",
-- 		name = "Debug (J-Link)",
-- 		device = "nrf52",
-- 		interface = "swd",
-- 		svdFile = "nrf5_sdk/modules/nrfx/mdk/nrf52.svd",
-- 		showDevDebugOutput = "raw",
-- 		-- serverArgs = {},
-- 		-- ipAddress= null,
-- 		-- serialNumber= null
-- 	},
-- 	{
-- 		request = "attach",
-- 		type = "cortex_debug",
-- 		name = "Debug Jlink (attach)",
-- 		servertype = "jlink",
-- 		serverpath = "/usr/bin/JLinkGDBServerCLExe",
-- 		cwd = vim.fn.getcwd(),
-- 		executable = "app/build/nrf52832_xxaa.out",
-- 		gdbPath = "/home/skobec/miniconda3/envs/apt/bin/arm-none-eabi-gdb",
-- 		device = "nrf52",
-- 		interface = "swd",
-- 		svdFile = "nrf5_sdk/modules/nrfx/mdk/nrf52.svd",
-- 		showDevDebugOutput = "raw",
-- 	},
-- }

-- dap.configurations.c = dap.configurations.cortex_debug
-- -- dapui.setup()

-- dap.listeners.after.event_initialized["dapui_config"] = function()
-- 	dapui.open()
-- end
-- dap.listeners.before.event_terminated["dapui_config"] = function()
-- 	dapui.close()
-- end
-- dap.listeners.before.event_exited["dapui_config"] = function()
-- 	dapui.close()
-- end
--
local dap = require("dap")
local dapui = require("dapui")

dap.adapters.cppdbg = {
	id = "cppdbg",
	type = "executable",
	command = "/home/skobec/Programs/cpptools/extension/debugAdapters/bin/OpenDebugAD7",
}

dap.configurations.cpp = {
	{
		name = "Launch file",
		type = "cppdbg",
		request = "launch",
		program = function()
			return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
		end,
		cwd = "${workspaceFolder}",
		stopAtEntry = true,
	},
	{
		name = "Attach to gdbserver :1234",
		type = "cppdbg",
		request = "launch",
		MIMode = "gdb",
		miDebuggerServerAddress = "localhost:1234",
		miDebuggerPath = "/usr/bin/gdb",
		cwd = "${workspaceFolder}",
		program = function()
			return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
		end,
	},
}
dap.configurations.c = dap.configurations.cpp

dapui.setup()

require("dap").set_log_level("DEBUG")

dap.listeners.after.event_initialized["dapui_config"] = function()
	dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
	dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
	dapui.close()
end
