vim.lsp.config.clangd        = {
  on_attach = function()
    print "Clangd Language Server Attached!"
  end,
  filetypes = {
    "c",
    "cpp",
    "objc",
    "objcpp",
    "cuda",
  },
  root_markers = {
    "compile_commands.json",
    "compile_flags.txt",
  },
  cmd = {
    "clangd",
    "--background-index",
    "--clang-tidy",
    "--header-insertion=iwyu",
    "--completion-style=detailed",
    "--function-arg-placeholders",
    "--fallback-style=llvm",
    "--pch-storage=memory",
  },
}

vim.lsp.enable("clangd")
