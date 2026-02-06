return {
  {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "VeryLazy",
    priority = 1000,
    config = function()
      vim.diagnostic.config { virtual_text = false } -- Disable Neovim's default virtual text diagnostics
      require "tiny-inline-diagnostic".setup {
        preset         = "ghost",
        transparent_bg = true,

        signs          = {
          left = "",
          right = "",
          diag = "🐇",
          arrow = "    ",
          up_arrow = "    ",
          vertical = " │",
          vertical_end = " └",
        },
        blend          = {
          factor = 0.22,
        },

        hi             = {
          error = "DiagnosticError", -- Highlight for error diagnostics
          warn = "DiagnosticWarn",   -- Highlight for warning diagnostics
          info = "DiagnosticInfo",   -- Highlight for info diagnostics
          hint = "DiagnosticHint",   -- Highlight for hint diagnostics
          arrow = "NonText",         -- Highlight for the arrow pointing to diagnostic
          background = "CursorLine", -- Background highlight for diagnostics
          mixing_color = "Normal",   -- Color to blend background with (or "None")
        },
        options        = {
          multilines = {
            enabled = true,           -- Enable support for multiline diagnostic messages
            always_show = false,      -- Always show messages on all lines of multiline diagnostics
            trim_whitespaces = false, -- Remove leading/trailing whitespace from each line
            tabstop = 4,              -- Number of spaces per tab when expanding tabs
            severity = nil,           -- Filter multiline diagnostics by severity (e.g., { vim.diagnostic.severity.ERROR })
          },
        },
      }
    end,
  },
}
