vim.lsp.config.qmlls.setup = {
  cmd = { "qmlls" },
  on_attach = function()
    print "Qmlls Language Server Attached!"
  end,
  filetypes = { "qml", "qmljs" },
  root_dir = function(fname)
    return vim.fs.root(fname, {
      "CMakeLists.txt",
      ".git",
      "qmlproject",
    })
  end,
  settings = {
    qml = {
      completion = {
        autoImport = true,
      },
    },
  },
}

vim.lsp.enable "qmlls"
