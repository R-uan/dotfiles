return {
  {
    -- Automatically creates the folder when using :e to write a file.
    "mateuszwieloch/automkdir.nvim",
    opts = {},
  },
  {
    -- Adds the intent line that shows where a block open and close
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    ---@module "ibl"
    ---@type ibl.config
    opts = {},
  },
  {
    -- Auto close [{""}]
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
    -- Better code block folding
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
    "nvim-pack/nvim-spectre",
    dependencies = { "nvim-lua/plenary.nvim" }, -- Plenary is a common dependency for many plugins
  },
}
