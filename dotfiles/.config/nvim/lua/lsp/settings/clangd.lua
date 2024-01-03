return {
	settings = {
		clangd = {
			filetypes = { "c", "cc", "cpp", "h", "objc", "objcpp" },
		},
	},
	capabilities = {
		offsetEncoding = { "utf-16" },
	},
	cmd = {
		"clangd",
		-- "--compile-commands-dir=tests/basic/build",
		"--background-index",
		"-j=8",
		"--log=error",
		"--query-driver=/usr/bin/**/clang-*,/bin/clang,/bin/clang++,/usr/bin/gcc,/usr/bin/g++,${env:HOME}/Programs/gnuarmemb/bin/arm-none-eabi-gcc",
		"--clang-tidy",
		"--all-scopes-completion",
		"--cross-file-rename",
		"--completion-style=detailed",
		"--header-insertion-decorators",
		"--header-insertion=iwyu",
		"--function-arg-placeholders",
		"--pch-storage=memory",
	},
}
