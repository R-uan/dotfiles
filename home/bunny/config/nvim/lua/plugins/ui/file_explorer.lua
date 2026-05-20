return {
  {
    -- Fuzzy finder
    'nvim-telescope/telescope.nvim',
    version = '*',
    dependencies = {
      'nvim-lua/plenary.nvim',
      -- optional but recommended
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    },
    opts = {
      defaults = {
        vimgrep_arguments = {
          "rg",
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
          "--smart-case",
          "--hidden",
          "--glob=!.git/*",
        },
      },
      pickers = {
        find_files = {
          hidden = false,
          no_ignore = false,
          no_ignore_parent = false,
        },
      },
    }
  },
  {
    -- Topbar
    "willothy/nvim-cokeline",
    dependencies = {
      "nvim-lua/plenary.nvim",       -- Required for v0.4.0+
      "nvim-tree/nvim-web-devicons", -- If you want devicons
    },
    config = true,
  },
  {
    -- leftside tree
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons", -- optional, but recommended
    },
    lazy = false,
    keys = {
      {
        "<C-b>",
        function()
          require("neo-tree.command").execute({ toggle = true, dir = vim.loop.cwd() })
        end,
        desc = "Toggle Neo-tree",
      },
    },
    opts = {
      window = {
        position = "right",
        width = 40,
      },
    },
    --@type LazySpec
    {
      "mikavilpas/yazi.nvim",
      version = "*", -- use the latest stable version
      event = "VeryLazy",
      dependencies = {
        { "nvim-lua/plenary.nvim", lazy = true },
      },
      keys = {
        -- 👇 in this section, choose your own keymappings!
        {
          "<leader>-",
          mode = { "n", "v" },
          "<cmd>Yazi<cr>",
          desc = "Open yazi at the current file",
        },
        {
          -- Open in the current working directory
          "<leader>cw",
          "<cmd>Yazi cwd<cr>",
          desc = "Open the file manager in nvim's working directory",
        },
        {
          "<c-up>",
          "<cmd>Yazi toggle<cr>",
          desc = "Resume the last yazi session",
        },
      },
      ---@type YaziConfig | {}
      opts = {
        -- if you want to open yazi instead of netrw, see below for more info
        open_for_directories = false,
        keymaps = {
          show_help = "<f1>",
        },
      },
      -- 👇 if you use `open_for_directories=true`, this is recommended
      init = function()
        -- mark netrw as loaded so it's not loaded at all.
        --
        -- More details: https://github.com/mikavilpas/yazi.nvim/issues/802
        vim.g.loaded_netrwPlugin = 1
      end,
    }
  }
}
