require("mason").setup({
  ui = {
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗",
    },
  },
})

require("mason-tool-installer").setup({
  ensure_installed = {
    "stylua",
    "lua-language-server",
    "shfmt",
    "shellcheck",
    "roslyn-language-server",
  },
  -- Setup now runs at startup; keep tool downloads opt-in.
  -- Use :MasonToolsInstall / :MasonToolsUpdate when needed.
  auto_update = false,
  run_on_start = false,
})
