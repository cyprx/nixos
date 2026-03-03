{ pkgs, ... }:

{
  imports = [ ./common.nix ];

  # WSL-only stuff
  home.username = "cyprx";
  home.homeDirectory = "/home/cyprx"; # Also use the absolute path
  home.stateVersion = "25.05";
  programs.home-manager.enable = true;
  home.packages = [];
}
