return {
  "rcarriga/nvim-notify",
  lazy = false,
  priority = 1000,
  opts = {
    background_colour = "#070707", -- black
    timeout = 3000,
    stages = "fade",
    render = "wrapped-compact",
  },
  config = function(_, opts)
    local notify = require "notify"
    notify.setup(opts)
    vim.notify = notify

    -- palette
    -- base
    vim.api.nvim_set_hl(0, "NotifyBackground", { bg = "#070707" })
    vim.api.nvim_set_hl(0, "NotifyBorder", { fg = "#3d4a34", bg = "#070707" }) -- dgreen

    -- levels
    vim.api.nvim_set_hl(0, "NotifyINFOBorder", { fg = "#7fb069" }) -- green
    vim.api.nvim_set_hl(0, "NotifyINFOIcon", { fg = "#7fb069" })

    vim.api.nvim_set_hl(0, "NotifyWARNBorder", { fg = "#D46A8C" })
    vim.api.nvim_set_hl(0, "NotifyWARNIcon", { fg = "#D46A8C" })

    vim.api.nvim_set_hl(0, "NotifyERRORBorder", { fg = "#D46A8C" })
    vim.api.nvim_set_hl(0, "NotifyERRORIcon", { fg = "#D46A8C" })

    vim.api.nvim_set_hl(0, "NotifyDEBUGBorder", { fg = "#556b47" }) -- greenAlt
    vim.api.nvim_set_hl(0, "NotifyTRACEBorder", { fg = "#3d4a34" })
  end,
}
