return {
  "SmiteshP/nvim-navic",
  lazy = true,
  init = function()
    -- Optional: set global variable to silence initial warnings
    vim.g.navic_silence = true
  end,
  opts = {
    separator = " ",
    highlight = true,
    depth_limit = 5,
    -- icons can be configured here
  },
}
