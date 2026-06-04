return {
  "stevearc/conform.nvim",
  opts = {
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
  keys = {
    {
      "<leader>fc",
      function()
        require "conform".format { timeout_ms = 500, lsp_fallback = true }
      end,
      desc = "Format buffer",
    },
  },
}
