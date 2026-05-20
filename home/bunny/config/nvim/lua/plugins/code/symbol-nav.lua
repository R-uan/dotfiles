return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      {
        "SmiteshP/nvim-navbuddy",
        dependencies = {
          "SmiteshP/nvim-navic",
          "MunifTanjim/nui.nvim"
        },
        opts = {
          lsp = { auto_attach = true },
          window = {
            border = "double",
            size = "80%",
            sections = {
              left = {
                size = "30%",
              },
              mid = {
                size = "30%",
              },
              right = {
                size = "40%",
              },
            },
          },
        },
      }
    },
  },
  {
    "rachartier/tiny-code-action.nvim",
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      -- optional picker via telescope
      { "nvim-telescope/telescope.nvim" },
    },
    event = "LspAttach",
    opts = {},
  },
}
