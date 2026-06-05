local capabilities          = require "blink.cmp".get_lsp_capabilities()

-- php
vim.lsp.config.phpantom_lsp = {
  filetypes = { 'php' },
  capabilities = capabilities,
  root_markers = { 'composer.json', '.git' },
  cmd = { "/home/bunny/.cargo/bin/phpantom_lsp" },
}

-- lua
vim.lsp.config.lua_ls       = {
  filetypes = { "lua" },
  cmd = { "lua-language-server" },
  root_markers = { { ".luarc.json", ".luarc.jsonc" }, ".git" },
  settings = {
    Lua = {
      workspace = {
        library = {
          "/usr/share/hypr/stubs",
        },
      },
      format = {
        enable = true,
        defaultConfig = {
          indent_size = "2",
          indent_style = "space",
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

-- c/cpp
vim.lsp.config.clangd       = {
  on_attach = function(client, bufnr)
    local navic = require "nvim-navic"
    navic.attach(client, bufnr)
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

-- csharp
vim.lsp.config.omnisharp    = {
  enable_editorconfig_support = true,
  settings = {
    FormattingOptions = {
      EnableEditorConfigSupport = true,
      OrganizeImports = true,
    },
  },
}

-- Only works with .NET 10+
vim.lsp.config.roslyn       = {
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

-- nix
vim.lsp.config.nil_ls       = {
  on_attach = function()
  end,
  settings = {
    ['nil'] = {
      formatting = {
        command = { "alejandra" },
      },
    },
  },
}

-- python
vim.lsp.config.pyright      = {
  on_attach = function(client, bufnr)
  end,
  filetypes = { "python" },
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
  root_markers = {
    "pyproject.toml",
    "setup.py",
    "setup.cfg",
    "requirements.txt",
    "Pipfile",
    ".git",
  },
}

-- typescript
vim.lsp.config.tsserver     = {
  on_attach = function(client, bufnr)
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
  root_markers = {
    ".git",
    "package.json",
    "jsconfig.json",
    "tsconfig.json",
  },
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

-- qml

vim.lsp.config.qmlls.setup  = {
  cmd = { "qmlls" },
  on_attach = function()
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

-- html/css
vim.lsp.config.cssls        = {
  on_attach = function()
  end,
  cmd = { 'vscode-css-language-server', '--stdio' },
  filetypes = { 'css', 'scss', 'less' },
  init_options = { provideFormatter = true }, -- needed to enable formatting capabilities
  root_markers = { 'package.json', '.git' },
  settings = {
    css = { validate = true },
    scss = { validate = true },
    less = { validate = true },
  },
}

vim.lsp.config.html         = {
  on_attach = function()
  end,
  cmd = { 'vscode-html-language-server', '--stdio' },
  filetypes = { 'html', 'templ' },
  root_markers = { 'package.json', '.git' },
  settings = {},
  init_options = {
    provideFormatter = true,
    embeddedLanguages = { css = true, javascript = true },
    configurationSection = { 'html', 'css', 'javascript' },
  },
}

vim.lsp.enable 'gleam'
vim.lsp.enable "html"
vim.lsp.enable "cssls"
vim.lsp.enable "qmlls"
vim.lsp.enable "tsserver"
vim.lsp.enable "pyright"
vim.lsp.enable "nil_ls"
vim.lsp.enable "roslyn"
vim.lsp.enable "clangd"
vim.lsp.enable "lua_ls"
vim.lsp.enable "phpantom_lsp"
