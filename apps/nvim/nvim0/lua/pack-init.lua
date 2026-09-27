assert(vim.fn.has("nvim-0.12") == 1, "This config requires Neovim 0.12+ (vim.pack)")

-- Register build hooks before add(), including installs restored from the lockfile.
vim.api.nvim_create_autocmd("PackChanged", {
  group = vim.api.nvim_create_augroup("UserPackBuild", { clear = true }),
  callback = function(ev)
    local data = ev.data
    if data.spec.name == "telescope-fzf-native.nvim"
      and (data.kind == "install" or data.kind == "update") then
      local result = vim.system({ "make" }, { cwd = data.path, text = true }):wait()
      if result.code ~= 0 then
        error("telescope-fzf-native build failed:\n" .. (result.stderr or result.stdout or ""))
      end
    end
  end,
})

-- Dependencies are explicit. Tree-sitter and its grammars come from Nix.
-- add() installs missing plugins; updates only happen via vim.pack.update().
vim.pack.add({
  { src = "https://github.com/nvim-lua/plenary.nvim" },
  { src = "https://github.com/nvim-tree/nvim-web-devicons" },
  { src = "https://github.com/rafamadriz/friendly-snippets" },
  { src = "https://github.com/ibhagwan/fzf-lua" },
  { src = "https://github.com/stevearc/oil.nvim" },
  { src = "https://github.com/ingur/fzf-oil.nvim" },
  { src = "https://github.com/FabijanZulj/blame.nvim" },
  { src = "https://github.com/saghen/blink.cmp", version = vim.version.range("1.*") },
  { src = "https://github.com/williamboman/mason.nvim" },
  { src = "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim" },
  { src = "https://github.com/nvim-mini/mini.align", version = vim.version.range("*") },
  { src = "https://github.com/nvim-mini/mini.files", version = vim.version.range("*") },
  { src = "https://github.com/nvim-mini/mini.indentscope", version = vim.version.range("*") },
  { src = "https://github.com/nvim-mini/mini.pairs", version = vim.version.range("*") },
  { src = "https://github.com/MeanderingProgrammer/render-markdown.nvim" },
  { src = "https://github.com/seblyng/roslyn.nvim" },
  { src = "https://github.com/nvim-telescope/telescope-fzf-native.nvim" },
  { src = "https://github.com/nvim-telescope/telescope.nvim", version = vim.version.range("*") },
  { src = "https://github.com/aliqyan-21/darkvoid.nvim" },
  { src = "https://github.com/oskarnurm/koda.nvim" },
  { src = "https://github.com/slugbyte/lackluster.nvim" },
  { src = "https://github.com/cyprx/grass.nvim" },
}, { confirm = false })

vim.cmd.colorscheme("grass")
require("blame").setup({})
require("mini.align").setup({})
require("mini.files").setup({})
require("mini.indentscope").setup({})
require("mini.pairs").setup({})
require("render-markdown").setup({})
require("plugins.blink")
require("plugins.mason")
require("plugins.roslyn")
