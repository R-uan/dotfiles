return {
  {
    -- Discord presence
    'vyfor/cord.nvim',
    build = ':Cord update',
    -- opts = {}
  },
  {
    "windwp/nvim-ts-autotag",
    ft = { "html", "javascriptreact", "typescriptreact", "astro" }, -- File types to enable it for
    config = function()
      require "nvim-ts-autotag".setup()
    end,
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
  {
    "SmiteshP/nvim-navbuddy",
    dependencies = {
      "SmiteshP/nvim-navic",
      "MunifTanjim/nui.nvim",
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
  },
  {
    "xiyaowong/transparent.nvim",
    opts = {},
  },
  {
    'gisketch/triforce.nvim',
    dependencies = { 'nvzone/volt' },
    opts = {},
  },
}
