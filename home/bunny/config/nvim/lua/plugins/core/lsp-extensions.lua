return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      {
        "SmiteshP/nvim-navbuddy",
        dependencies = {
          "SmiteshP/nvim-navic",
          "MunifTanjim/nui.nvim",
        },
        opts = { lsp = { auto_attach = true } },
      },
    },
  },
  {
    "seblyng/roslyn.nvim",
    ---@module 'roslyn.config'
    ---@type RoslynNvimConfig
    opts = {
      -- your configuration comes here; leave empty for default settings
    },
  },
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
    'akinsho/flutter-tools.nvim',
    lazy = false,
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    config = function()
      require "flutter-tools".setup {
        lsp = {
          color = {
            enabled = true, -- Show colors in code
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
  {
    "Jezda1337/nvim-html-css",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      enable_on = {
        "html",
        "htmldjango",
        "tsx",
        "jsx",
        "erb",
        "svelte",
        "vue",
        "blade",
        "php",
        "templ",
        "astro",
      },
      handlers = {
        definition = {
          bind = "gd",
        },
        hover = {
          bind = "K",
          wrap = true,
          border = "none",
          position = "cursor",
        },
      },
      documentation = {
        auto_show = true,
      },
      style_sheets = {
        "https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css",
        "https://cdnjs.cloudflare.com/ajax/libs/bulma/1.0.3/css/bulma.min.css",
        "./index.css", -- `./` refers to the current working directory.
      },
    },
  },
}
