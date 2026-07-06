return {
  "oskarnurm/koda.nvim",
  lazy = true,
  priority = 1000,
  config = function()
    -- require("koda").setup({ transparent = true })
    require("koda").setup({
      -- theme = { dark = "dark", light = "glade" }
    })
    -- vim.cmd("colorscheme koda")
  end,
}
