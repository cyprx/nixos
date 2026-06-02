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


vim.lsp.enable('lua_ls')
