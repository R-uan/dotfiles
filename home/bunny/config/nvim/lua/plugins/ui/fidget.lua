return {
  "j-hui/fidget.nvim",
  event = "LspAttach",
  opts = {
    notification = {
      window = {
        winblend = 0,
        border = "rounded",
      },
    },
  },
  config = function(_, opts)
    require "fidget".setup(opts)

    vim.api.nvim_set_hl(0, "FidgetTitle", {
      fg = "#7fb069", -- green
      bg = "#070707",
    })

    vim.api.nvim_set_hl(0, "FidgetTask", {
      fg = "#a8c69f", -- lgreen
      bg = "#070707",
    })
  end,
}
