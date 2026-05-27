{ config, pkgs, inputs, user, ... }:

{
  imports = [
    ../apps/nvim/nvim.nix
  ];
  home.stateVersion = "25.05";
  home.username = user.username;
  home.homeDirectory = user.homeDirectory;

  home.packages = with pkgs; [
    opencode
    cmake
    zoxide
    wget
    nerd-fonts.caskaydia-cove
  ];

  fonts.fontconfig.enable = true;

  # Shell
  home.sessionVariables = {
    EDITOR = "vi";
  };
  programs.fish = {
    enable = true;
    shellAliases = {
      gs = "git status";
      gd = "git diff";
      se = "sudoedit";
      vim = "nvim";

      nix-re =
        if pkgs.stdenv.isDarwin
        then "sudo darwin-rebuild switch --flake ~/workplace/nix-darwin#cymacos"
        else "sudo nixos-rebuild switch --flake /etc/nixos";
    };
    functions = {
      fish_greeting = "";
    };
    plugins = [
      { name = "fzf-fish"; src = pkgs.fishPlugins.fzf-fish.src; }
    ];
  };

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
    enableBashIntegration = true;
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      add_newline = false;
    };
  };

  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
  };

  # Git
  programs.git = {
    enable = true;
    settings = {
      url = {
        "ssh://git@github.com/" = {
          insteadOf = "https://github.com/";
        };
      };
      safe.directory = ["/etc/nixos"];
    };
  };
  
  # Terminal
  programs.kitty = {
    enable = true;

    themeFile = "Nord";

    font = {
      name = "caskaydia-cove";
      size = 12;
    };

    settings = {
      term = "xterm-256color";
      "modify_font" = "cell_height 110%";
      scrollback_lines = 10000;
      enable_audio_bell = false;
      update_check_interval = 0;
      
      # Window layout
      window_padding_width = 4;
      placement_strategy = "center";
      
      hide_window_decorations = "yes";
      
      # Transparency (optional)
      background_opacity = "0.99";
      background_blur = 1;
    };

    # Keybindings (optional)
    keybindings = {
      "ctrl+shift+c" = "copy_or_interrupt";
      "ctrl+shift+v" = "paste_from_clipboard";
      "ctrl+shift+enter" = "new_window";
      "ctrl+shift+w" = "close_window";
      "ctrl+shift+]" = "next_tab";
      "ctrl+shift+[" = "previous_tab";
    };

    # Shell integration (optional, often enabled by default)
    shellIntegration = {
      enableBashIntegration = true;
      enableZshIntegration = true;
    }; 
  };
  programs.jq.enable = true;

  # Editors
  # programs.helix.package = inputs.helix.packages.${pkgs.system}.default;
  programs.helix = {
    enable = true;
    settings = {
      theme = "darkvoid";
      editor = {
        line-number = "absolute";
        cursorline = true;
        bufferline = "multiple";
        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };
        lsp.display-messages = true;
      };
    };

    extraPackages = with pkgs; [
    ];

    languages = {
      language = [
        {
          name = "nix";
          auto-format = true;
        }
        {
          name = "java";
          auto-format = false;
          language-servers = [ "jdtls" ];
        }
        {
          name = "go";
          auto-format = true;
        }
      ];
    };
  };
  xdg.configFile."helix/themes/darkvoid.toml".source = "${inputs.darkvoid-theme}/darkvoid.toml";

  programs.gh = {
    enable = true;
    extensions = [ pkgs.gh-dash ];
  };

  programs.gh-dash = {
    enable = true;
    settings = {
    };
  };
}
