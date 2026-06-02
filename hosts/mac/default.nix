{ pkgs, user, ... }:

{
  nix.enable = false;

  users.users.${user.username} = {
    name = user.username;
    home = user.homeDirectory;
  };

  system.primaryUser = user.username;

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      cleanup = "zap"; # Removes unlisted casks/formulae
    };
    
    # 2. Add Google Chrome
    casks = [
      "google-chrome"
      "kitty"
      "orbstack"
      "obsidian"
      "rectangle"
      "telegram"
      "ghostty"
      "dbeaver-community"
      "visual-studio-code"
    ];
  };


  system.stateVersion = 5;
}
