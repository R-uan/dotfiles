vim.lsp.config.lua_ls        = {
  filetypes = { "lua" },
  cmd = { "lua-language-server" },
  root_markers = { { ".luarc.json", ".luarc.jsonc" }, ".git" },
  settings = {
    Lua = {
      format = {
        enable = true,
        defaultConfig = {
          indent_style = "space",
          indent_size = "2",
          quote_style = "double,",
          call_arg_parentheses = "remove",
          trailing_table_separator = "smart",
        },
      },
      runtime = {
        version = "LuaJIT",
      },
    },
  },
}

vim.lsp.enable("lua_ls")
