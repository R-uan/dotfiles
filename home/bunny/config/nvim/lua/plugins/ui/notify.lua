return {
  "rcarriga/nvim-notify",
  lazy = false,
  priority = 1000,
  opacity = 1,
  opts = {
    background_colour = "#000000", -- black
    timeout = 3000,
    stages = "fade_in_slide_out",
    render = "wrapped-default",
  },
  config = function(_, opts)
    local notify = require "notify"
    notify.setup(opts)
    vim.notify = notify
  end,
}
