return {
  {
    "folke/lazydev.nvim",
    lazy = false,
    ft = "lua",
    opts = {},
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      {
        "SmiteshP/nvim-navbuddy",
        dependencies = {
          "SmiteshP/nvim-navic",
          "MunifTanjim/nui.nvim",
        },
        opts = {
          diagnostics = { virtual_text = false },
          lsp = { auto_attach = true }
        },
      },
    },
  },
}
