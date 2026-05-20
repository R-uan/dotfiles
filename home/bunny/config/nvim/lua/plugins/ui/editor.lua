return {
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    ---@module "ibl"
    ---@type ibl.config
    opts = {},
  },
  {
    "nvim-mini/mini.pairs",
    opts = {
      modes = { insert = true, command = true, terminal = false },
      -- skip autopair when next character is one of these
      skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
      -- skip autopair when the cursor is inside these treesitter nodes
      skip_ts = { "string" },
      -- skip autopair when next character is closing pair
      -- and there are more closing pairs than opening pairs
      skip_unbalanced = true,
      -- better deal with markdown code blocks
      markdown = true,
    },
  },
  {
    "kevinhwang91/nvim-ufo",
    dependencies = { { "kevinhwang91/promise-async" } },
    event = "VeryLazy",
    opts = {
      provider_selector = function(bufnr, filetype, buftype)
        return { "treesitter", "indent" }
      end,
    },
  },
  {
    'stevearc/dressing.nvim',
    opts = {},
  },
  {
    -- Notification
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
  },
  {
    -- Multi select and editor
    "mg979/vim-visual-multi",
    branch = "master",
    lazy = false, -- add this
    init = function()
      vim.g.VM_default_mappings = 0
      vim.g.VM_maps = {
        ["Find Under"] = "<F3>",
        ["Find Subword Under"] = "<F3>",
        ["Skip Region"] = "<C-x>",
        ["Remove Region"] = "<C-u>",
      }
    end,
    keys = {
      { "<F3>", mode = { "n", "x" }, desc = "Multi cursor" },
    },
  },
  {
    -- Comment line
    'numToStr/Comment.nvim',
    opts = {
      -- add any options here
    }
  }
}
