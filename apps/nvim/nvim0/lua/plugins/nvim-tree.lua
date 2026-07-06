return {
  "nvim-tree/nvim-tree.lua",
  version = "*",
  priority = 1000,
  lazy = false,
  enabled = false,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    require("nvim-tree").setup {}
  end,
}
