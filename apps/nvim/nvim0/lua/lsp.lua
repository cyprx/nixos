vim.lsp.config('lua_ls', {
    settings = {
        Lua = {
            runtime = { version = 'LuaJIT' },
            diagnostics = {
                globals = { 'vim' },
            },
            workspace = {

            },
            telemetry = { enable = false },
        },
    },
})

vim.lsp.config("ra", {
	cmd = { "rust-analyzer" },
	settings = {
		["rust-analyzer"] = {
			files = { watcher = "server" },
			cargo = { targetDir = true },
			check = { command = "clippy" },
			inlayHints = {
				bindingModeHints = { enabled = true },
				closureCaptureHints = { enabled = true },
				closureReturnTypeHints = { enable = "always" },
				maxLength = 100,
			},
			rustc = { source = "discover" },
		},
	},
	root_markers = { { "Config.toml" }, ".git" },
})



vim.lsp.enable('lua_ls')
vim.lsp.enable('ra')
