return {
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

    views = {
      cmdline_popup = {
        border = {
          style = "rounded",
        },
        position = {
          row = "40%",
          col = "50%",
        },
        size = {
          width = 60,
          height = "auto",
        },
      },
    },

    presets = {
      bottom_search = false,
      command_palette = true,
      long_message_to_split = false,
      inc_rename = true,
      lsp_doc_border = true,
    },
  },
  config = function(_, opts)
    require "noice".setup(opts)

    vim.api.nvim_set_hl(0, "NoiceCmdlinePopup", {
      bg = "#070707",
      fg = "#a8c69f", -- lgreen
    })

    vim.api.nvim_set_hl(0, "NoiceCmdlinePopupBorder", {
      bg = "#070707",
      fg = "#7fb069", -- dgreen
    })

    vim.api.nvim_set_hl(0, "NoiceCmdlineIcon", {
      fg = "#7fb069", -- green (PRIMARY)
    })

    vim.api.nvim_set_hl(0, "NoiceConfirmBorder", {
      fg = "#7fb069",
      bg = "#070707",
    })

    vim.api.nvim_set_hl(0, "NoicePopupmenuMatch", {
      fg = "#7fb069",
      bold = true,
    })
  end,
}
