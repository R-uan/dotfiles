vim.lsp.config['terraform_ls'] = {
  cmd = { 'terraform-ls', 'serve' },
  filetypes = { 'terraform', 'terraform-vars', 'tf' },
  root_dir = vim.fs.root(0, { '.terraform', '.git' }),
  capabilities = vim.lsp.protocol.make_client_capabilities(),
  settings = {
    ['terraform-ls'] = {
      experimentalFeatures = {
        validateOnSave = true,
        prefillRequiredFields = true,
      },
    },
  },
}

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'terraform', 'terraform-vars' },
  callback = function(args)
    vim.lsp.enable 'terraform-ls'
  end,
})

vim.lsp.enable "terraform_ls"
