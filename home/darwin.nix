{ pkgs, ... }:
{
  imports = [ ./common.nix ]; 
  
  # Mac-only stuff
  home.homeDirectory = "/Users/cyprx"; # Also use the absolute path
  home.packages = []; 
}
