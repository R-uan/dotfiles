return {
  "stevearc/conform.nvim",
  opts = {
    format_on_save = {
      timeout_ms = 500,
      lsp_format = "fallback",
    },
    formatters_by_ft = {
      qml = { "qmlformat" },
      cpp = { "clang-format" },
      typescript = { "prettier" },
      javascript = { "prettier" },
      nix = { "alejandra" },
    },
  },
}
