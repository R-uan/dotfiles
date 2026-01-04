vim.lsp.config.nil_ls = {
  on_attach = function()
    print "Nil Language Server Attached!"
  end,
  settings = {
    ['nil'] = {
      formatting = {
        command = { "alejandra" },
      },
    },
  },
}

vim.lsp.enable "nil_ls"
