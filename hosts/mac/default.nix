{ pkgs, ... }:

{
  nix.enable = false;

  users.users.cyprx = {
    name = "cyprx";
    home = "/Users/cyprx"; # Use the absolute path
  };

  system.stateVersion = 5;
}
