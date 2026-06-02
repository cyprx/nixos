return {
    'cyprx/grass.nvim',
    lazy = false,
    priority = 1000,
    config = function()
        vim.cmd("colorscheme grass") -- Activate the theme here
    end,
}
