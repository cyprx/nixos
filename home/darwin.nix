{ pkgs, ... }:
{
  imports = [ ./common.nix ];

  # Mac-only stuff
  home.packages = [
    pkgs.dotnet-sdk_10
  ];

  programs.ghostty = {
    enable = true;
    # Set to null if using the Homebrew cask to avoid build errors
    package = null; 
    
    settings = {
        theme = "black-metal";
        font-family = "Noto Nerd Font";
        font-size = 14;
        window-decoration = true;
        macos-titlebar-style = "tabs";
        confirm-close-surface = true;
    };
  };
}
