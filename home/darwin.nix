{ pkgs, ... }:
{
  imports = [ ./common.nix ];

  # Mac-only stuff
  home.packages = [

  ];
  programs.ghostty = {
    enable = true;
    # Set to null if using the Homebrew cask to avoid build errors
    package = null; 
    
    settings = {
        font-family = "Noto Nerd Font";
        font-size = 14;
        window-decoration = true;
        confirm-close-surface = true;
    };
  };


}
