return {
  'nvim-telescope/telescope.nvim',
  tag = '0.1.8',
  branch = '0.1.x',
  dependencies = { 'nvim-lua/plenary.nvim' },
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
}
