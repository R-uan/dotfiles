vim.lsp.config.clangd = {
	filetypes = { "c", "cpp" },
	cmd = { "clangd", "--background-index" },
	root_markers = { "compile_commands.json", "compile_flags.txt" },
}

vim.lsp.config.rust_analyzer = {
	filetypes = { "rs" },
	cmd = { "rust_analyzer" },
	root_markers = { "Cargo.lock", "Cargo.toml", ".git" },
}

vim.lsp.config.lua_ls = {
	filetypes = { "lua" },
	cmd = { "lua-language-server" },
	root_markers = { { ".luarc.json", ".luarc.jsonc" }, ".git" },
	settings = {
		Lua = {
			runtime = {
				version = "LuaJIT",
			},
		},
	},
}

vim.lsp.enable({ "clangd", "rust_analyzer", "lua_ls" })
