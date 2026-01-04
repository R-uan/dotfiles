return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    preset = "helix",
    plugins = {
      presets = {
        g = true, -- bindings for folds, spelling and others prefixed with z
        z = true, -- bindings for prefixed with g
      },
    },
  },
  keys = {
    {
      "<leader>?",
      function()
        require "which-key".show { global = false }
      end,
      desc = "Buffer Local Keymaps (which-key)",
    },
  },
}
