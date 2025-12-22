vim.lsp.config.clangd        = {
  on_attach = function()
    print "Clangd Language Server Attached!"
  end,
  filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
  root_markers = { "compile_commands.json", "compile_flags.txt" },
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

vim.lsp.config.omnisharp     = {
  enable_editorconfig_support = true,
  settings = {
    FormattingOptions = {
      EnableEditorConfigSupport = true,
      OrganizeImports = true,
    },
  },
}

vim.lsp.config.nil_ls        = {
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

vim.lsp.config.roslyn        = {
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

vim.lsp.config.gopls.setup   = {
  on_attach = function()
    print "Gopls Language Server Attached!"
  end,
  cmd = { "gopls" },
  filetypes = { "go", "gomod", "gowork", "gotmpl" },
  root_dir = require 'lspconfig/util'.root_pattern("go.work", "go.mod", ".git"),
  settings = {
    gopls = { -- Settings need to be nested under 'gopls'
      analyses = {
        unusedparams = true,
      },
      staticcheck = true,
      gofumpt = true,
      hints = {
        constantValues = true,
        functionTypeParameters = true,
        parameterNames = true,
        assignVariableTypes = true,
      },
    },
  },
}

vim.lsp.config.ts_ls.setup   = {
  on_attach = function(client, bufnr)
    print "TypeScript Language Server Attached!"

    -- Disable formatting (use prettier or eslint instead)
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
  end,
  filetypes = {
    "tsx", "jsx", "js", "ts",
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx",
  },
  cmd = { "typescript-language-server", "--stdio" },
  root_dir = require 'lspconfig/util'.root_pattern("package.json", "tsconfig.json", "jsconfig.json", ".git"),
  settings = {
    typescript = {
      inlayHints = {
        includeInlayParameterNameHints = 'all',
        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = true,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayEnumMemberValueHints = true,
      },
    },
    javascript = {
      inlayHints = {
        includeInlayParameterNameHints = 'all',
        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = true,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayEnumMemberValueHints = true,
      },
    },
  },
}

vim.lsp.config.pyright.setup = {
  on_attach = function(client, bufnr)
    print "Pyright Language Server Attached!"
  end,
  settings = {
    python = {
      analysis = {
        autoSearchPaths = true,
        diagnosticMode = "openFilesOnly",
        useLibraryCodeForTypes = true,
        typeCheckingMode = "basic",
        autoImportCompletions = true,
      },
    },
  },
  root_dir = require 'lspconfig/util'.root_pattern(
    "pyproject.toml",
    "setup.py",
    "setup.cfg",
    "requirements.txt",
    "Pipfile",
    ".git"
  ),
}

vim.lsp.enable {
  "clangd",
  "lua_ls",
  "roslyn",
  "nil_ls",
  "gopls",
  "ts_ls",
  "pyright",
}
