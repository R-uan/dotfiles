return {
  {
    "emrearmagan/dockyard.nvim",
    dependencies = {
      "akinsho/toggleterm.nvim",
    },
    keys = {
      {
        "<leader>dd",
        function()
          vim.cmd "Dockyard"
        end,
        desc = "Open Dockyard",
      },
    },
    config = function()
      require "dockyard".setup {}
    end,
  },
}
