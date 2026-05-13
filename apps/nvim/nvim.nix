{ pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    plugins = with pkgs.vimPlugins; [
    ];

    # External packages needed for Neovim (LSPs, Formatters)
    extraPackages = with pkgs; [
      lua-language-server
      nil # Nix LSP
      ripgrep
    ];
  };

  # Link your existing Lua config folder to ~/.config/nvim
  xdg.configFile."nvim" = {
    source = ./config;
    recursive = true;
  };
}
