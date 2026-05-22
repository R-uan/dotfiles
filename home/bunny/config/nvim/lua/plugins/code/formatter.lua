return {
  "stevearc/conform.nvim",
  opts = {
    format_on_save = function(bufnr)
      local ft = vim.bo[bufnr].filetype
      if ft == "php" then
        return
      end

      return { timeout_ms = 500, lsp_fallback = true }
    end,
    formatters_by_ft = {
      python = { "yapf", "-i" },
      qml = { "qmlformat" },
      cpp = { "clang-format" },
      typescript = { "prettier" },
      javascript = { "prettier" },
      javascriptreact = { "prettier" },
      typescriptreact = { "prettier" },
      nix = { "alejandra" },
    },
  },
}

