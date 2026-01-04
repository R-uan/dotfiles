vim.lsp.config.omnisharp = {
  enable_editorconfig_support = true,
  settings = {
    FormattingOptions = {
      EnableEditorConfigSupport = true,
      OrganizeImports = true,
    },
  },
}

-- Only works with .NET 10+
vim.lsp.config.roslyn    = {
  on_attach = function()
    print "Roslyn Language Server Attached!"
  end,
  settings = {
    ["csharp|inlay_hints"] = {
      csharp_enable_inlay_hints_for_implicit_object_creation = true,
      csharp_enable_inlay_hints_for_implicit_variable_types = true,
    },
    ["csharp|code_lens"] = {
      dotnet_enable_references_code_lens = true,
    },
  },
}

vim.lsp.enable "roslyn"
