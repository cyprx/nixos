{ pkgs, user, ... }:
{
  imports = [ ./common.nix ];

  # Mac-only stuff
  home.packages = [
    pkgs.dotnet-sdk_10
  ];

  home.sessionVariables = {
    DOTNET_ROOT = "${pkgs.dotnet-sdk_10}/share/dotnet";
  };

  programs.ghostty = {
    enable = true;
    # Set to null if using the Homebrew cask to avoid build errors
    package = null; 
    
    settings = {
        font-family = "Meslo";
        font-size = 14;
        window-decoration = true;
        macos-titlebar-style = "tabs";
        confirm-close-surface = true;
        command = "/run/current-system/sw/bin/fish --login --interactive"; 
        shell-integration = "fish";
    };
  };
}
