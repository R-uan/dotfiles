vim.lsp.config.kotlin_language_server = {
  cmd = { 'kotlin-language-server' },
  root_dir = require 'lspconfig.util'.root_pattern(
    'settings.gradle.kts',
    'settings.gradle',
    'build.gradle.kts',
    'build.gradle'
  ),
  -- Don't pass initializationOptions or workspace.configuration as arrays
  init_options = {
    storagePath = vim.fn.stdpath 'data' .. '/kotlin-language-server',
  },
  settings = {
    kotlin = {
      -- Server settings go here as an object, not array
    },
  }
}

vim.lsp.enable 'kotlin_language_server'
