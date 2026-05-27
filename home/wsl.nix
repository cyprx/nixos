{ pkgs, ... }:

{
  imports = [ ./common.nix ];

  # WSL-only stuff
  home.stateVersion = "25.05";
  programs.home-manager.enable = true;
  home.packages = [];
}
