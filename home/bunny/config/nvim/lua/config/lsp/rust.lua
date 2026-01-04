return {
  {
    "mrcjkb/rustaceanvim",
    version = "^5",
    lazy = false,
    ft = { "rust" },
    config = function()
      vim.g.rustaceanvim = {
        -- LSP configuration
        server = {
          on_attach = function(client, bufnr)
            -- Keymaps
            vim.keymap.set("n", "K", function()
              vim.cmd.RustLsp { "hover", "actions" }
            end, { buffer = bufnr, desc = "Rust hover actions" })

            vim.keymap.set("n", "<leader>ca", function()
              vim.cmd.RustLsp "codeAction"
            end, { buffer = bufnr, desc = "Rust code action" })
          end,
          default_settings = {
            ["rust-analyzer"] = {
              checkOnSave = {
                enable = true,
                command = "clippy",
              },
              cargo = {
                allFeatures = true,
              },
              rustfmt = {
                extraArgs = { "--config", "tab_spaces=2" },
              },
            },
          },
        },
        -- Tools configuration
        tools = {
          hover_actions = {
            auto_focus = true,
          },
        },
      }
    end,
  },
  {
    "saecki/crates.nvim",
    event = { "BufRead Cargo.toml" },
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require "crates".setup()
    end,
  },
}
