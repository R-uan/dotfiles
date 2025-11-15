return {
	"stevearc/conform.nvim",
	opts = {
		format_on_save = {
			timeout_ms = 500,
			lsp_format = "fallback",
		},
		formatters_by_ft = {
			cpp = { "clang-format" },
			typescript = { "prettier" },
			javascript = { "prettier" },
			rust = { "rustfmt", lsp_format = "fallback" },
			lua = { "stylua" },
			qml = { "qmlformat" },
		},
	},
}
