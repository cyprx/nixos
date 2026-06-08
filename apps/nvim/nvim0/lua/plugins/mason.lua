return {
  {
    "williamboman/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonUninstall", "MasonUninstallAll", "MasonLog" },
    opts = {
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    },
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "williamboman/mason.nvim" },
    cmd = { "MasonToolsInstall", "MasonToolsUpdate", "MasonToolsClean" },
    opts = {
      -- A list of all tools you want to ensure are installed
      ensure_installed = {
        "stylua",          
        "lua-language-server",
        "shfmt",           
        "shellcheck",      
        "roslyn-language-server",
      },
      
      -- Automatically install tools on startup
      auto_update = true,     -- Update installed tools on startup if new versions exist
      run_on_start = true,    -- Run the installer on startup
      start_delay = 3000,     -- Delay (in ms) to prevent blocking Neovim at startup
    },
  },
}
