return {
  -- This is the comand line :
  "folke/noice.nvim",
  event = "VeryLazy",
  dependencies = {
    "rcarriga/nvim-notify",
    "MunifTanjim/nui.nvim",
  },
  opts = {
    lsp = {
      progress = { enabled = false }, -- fidget handles this
      hover = { enabled = true },
      signature = { enabled = true },
    },

    cmdline = {
      view = "cmdline_popup",
    },

    messages = {
      view = "notify",
      view_error = "notify",
      view_warn = "notify",
      view_history = "messages",
      view_search = false,
    },

    popupmenu = {
      enabled = true,
      backend = "nui",
    },

    presets = {
      -- you can enable a preset by setting it to true, or a table that will override the preset config
      -- you can also add custom presets that you can enable/disable with enabled=true
      bottom_search = true,          -- use a classic bottom cmdline for search
      command_palette = false,       -- position the cmdline and popupmenu together
      long_message_to_split = false, -- long messages will be sent to a split
      inc_rename = false,            -- enables an input dialog for inc-rename.nvim
    },

    views = {
      cmdline_popup = {
        border = {
          style = "none",
          padding = { 1, 2 },
        },
        filter_options = {},
        win_options = {
          winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
        },
      },
    },
  },
  config = function(_, opts)
    require "noice".setup(opts)
  end,
}
