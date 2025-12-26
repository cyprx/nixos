{ config, pkgs, inputs, ... }:

{
  home.stateVersion = "25.05";

  imports = [
    inputs.niri.homeModules.niri
  ];

  home.packages = with pkgs; [
    xwayland-satellite
    neofetch
    htop
    tmux
    kitty
    fuzzel
    waybar
    swaybg
    mako
    wl-clipboard
    ripgrep
    fd
    xclip
    nixd
    lua-language-server
    gnumake
    docker-compose
    posting
    nerd-fonts.ubuntu-mono
    nodejs
    moor
    pamixer
    playerctl
    gemini-cli
    wtfutil

    # apps
    slack
    telegram-desktop
    bruno
    zoom-us
    dbeaver-bin
    anydesk

    # games
    lutris
    wineWow64Packages.stable
    winetricks
  ];

  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-mozc
      fcitx5-gtk
      fcitx5-bamboo
    ];
  };

  fonts.fontconfig.enable = true;

  # Lock screen
  programs.swaylock = {
  enable = true;
  settings = {
      image = "./assets/wallhaven-oggvw9.jpg";
      color = "1e1e2e";          # Dark background as a fallback
      font = "UbuntuMono Nerd Font";
      font-size = 24;
      indicator-idle-visible = false;
      indicator-radius = 100;
      show-failed-attempts = true;
    
      # Ring styling
      ring-color = "89b4fa";     # Blue ring
      inside-wrong-color = "f38ba8"; # Red for error
      ring-wrong-color = "f38ba8";
      key-hl-color = "a6e3a1";   # Green keypress feedback
      bs-hl-color = "f38ba8";    # Red backspace feedback
    };
  }; 

  services.swayidle = {
  enable = true;
  events = [
      # Lock before system sleep
      { event = "before-sleep"; command = "${pkgs.swaylock}/bin/swaylock -f"; }
      # Lock before lid close (if handled by logind, this adds an extra layer)
      { event = "lock"; command = "${pkgs.swaylock}/bin/swaylock -f"; }
    ];
    timeouts = [
      # Auto-lock after 5 minutes
      { 
        timeout = 300; 
        command = "${pkgs.swaylock}/bin/swaylock -f"; 
      }
      # Sleep after 10 minutes
      { 
        timeout = 600; 
        command = "${pkgs.systemd}/bin/systemctl suspend"; 
      }
    ];
  };

  # Niri - desktop
  programs.niri = {
    enable = true;

    settings = {
      prefer-no-csd = true;

      layout = {
        gaps = 16;
      };

      spawn-at-startup = [
        { command = ["xwayland-satellite"]; }
      ];

      binds = with config.lib.niri.actions; {
        # -- System --
        "Mod+Shift+S".action.spawn = ["sh" "-c" "swaylock" "-f" "&&" "systemctl suspend"];

        # -- Apps --
        "Mod+E".action.spawn = "kitty";
        "Mod+D".action.spawn = "fuzzel";
        "Mod+Shift+W".action.spawn = "waybar";

        # -- Window Management --
        "Mod+Q".action.close-window = [];
        "Mod+F".action.maximize-column = [];
        "Mod+Shift+E".action.quit.skip-confirmation = true;
        "Mod+Shift+P".action.power-off-monitors = [];
        "Mod+Shift+F".action.fullscreen-window = [];
        "Mod+C".action.center-column = [];
        
        # Focus (Vim-style + Arrows)
        "Mod+Left".action.focus-column-left = [];
        "Mod+Right".action.focus-column-right = [];
        "Mod+Down".action.focus-window-down = [];
        "Mod+Up".action.focus-window-up = [];
        "Mod+H".action.focus-column-left = [];
        "Mod+L".action.focus-column-right = [];
        "Mod+J".action.focus-window-down = [];
        "Mod+K".action.focus-window-up = [];
        
        # Move Columns/Windows
        "Mod+Ctrl+Left".action.move-column-left = [];
        "Mod+Ctrl+Right".action.move-column-right = [];
        "Mod+Ctrl+Down".action.move-window-down = [];
        "Mod+Ctrl+Up".action.move-window-up = [];
        "Mod+Ctrl+H".action.move-column-left = [];
        "Mod+Ctrl+L".action.move-column-right = [];
        "Mod+Ctrl+J".action.move-window-down = [];
        "Mod+Ctrl+K".action.move-window-up = [];

        # Column & Window Resizing
        "Mod+Minus".action.set-column-width = "-10%";
        "Mod+Equal".action.set-column-width = "+10%";
        "Mod+Shift+Minus".action.set-window-height = "-10%";
        "Mod+Shift+Equal".action.set-window-height = "+10%";
        "Mod+R".action.switch-preset-column-width = [];
        "Mod+Shift+R".action.switch-preset-window-height = [];
        "Mod+Ctrl+R".action.reset-window-height = [];

        # Floating Mode
        "Mod+V".action.toggle-window-floating = [];
        "Mod+Shift+V".action.switch-focus-between-floating-and-tiling = [];

        # -- Workspaces --
        "Mod+Home".action.focus-column-first = [];
        "Mod+End".action.focus-column-last = [];
        "Mod+Ctrl+Home".action.move-column-to-first = [];
        "Mod+Ctrl+End".action.move-column-to-last = [];
        
        "Mod+Page_Down".action.focus-workspace-down = [];
        "Mod+Page_Up".action.focus-workspace-up = [];
        "Mod+Ctrl+Page_Down".action.move-column-to-workspace-down = [];
        "Mod+Ctrl+Page_Up".action.move-column-to-workspace-up = [];
        "Mod+Shift+Page_Down".action.move-workspace-down = [];
        "Mod+Shift+Page_Up".action.move-workspace-up = [];

        # Numbered Workspaces (1-9)
        "Mod+1".action.focus-workspace = 1;
        "Mod+2".action.focus-workspace = 2;
        "Mod+3".action.focus-workspace = 3;
        "Mod+4".action.focus-workspace = 4;
        "Mod+5".action.focus-workspace = 5;
        "Mod+6".action.focus-workspace = 6;
        "Mod+7".action.focus-workspace = 7;
        "Mod+8".action.focus-workspace = 8;
        "Mod+9".action.focus-workspace = 9;
        
        "Mod+Ctrl+1".action.move-column-to-workspace = 1;
        "Mod+Ctrl+2".action.move-column-to-workspace = 2;
        "Mod+Ctrl+3".action.move-column-to-workspace = 3;
        "Mod+Ctrl+4".action.move-column-to-workspace = 4;
        "Mod+Ctrl+5".action.move-column-to-workspace = 5;
        "Mod+Ctrl+6".action.move-column-to-workspace = 6;
        "Mod+Ctrl+7".action.move-column-to-workspace = 7;
        "Mod+Ctrl+8".action.move-column-to-workspace = 8;
        "Mod+Ctrl+9".action.move-column-to-workspace = 9;

        # -- Monitor Focus --
        "Mod+Shift+Left".action.focus-monitor-left = [];
        "Mod+Shift+Right".action.focus-monitor-right = [];
        "Mod+Shift+Up".action.focus-monitor-up = [];
        "Mod+Shift+Down".action.focus-monitor-down = [];
        "Mod+Shift+Ctrl+Left".action.move-column-to-monitor-left = [];
        "Mod+Shift+Ctrl+Right".action.move-column-to-monitor-right = [];
        "Mod+Shift+Ctrl+Up".action.move-column-to-monitor-up = [];
        "Mod+Shift+Ctrl+Down".action.move-column-to-monitor-down = [];

        # -- Screenshots --
        "Print".action.spawn = ["niri" "msg" "action" "screenshot"];
        "Alt+Print".action.spawn = ["niri" "msg" "action" "screenshot"];
        "Mod+S".action.spawn = ["niri" "msg" "action" "screenshot"];

        # -- Audio & Media --
        "XF86AudioRaiseVolume".action.spawn = [ "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1+" ];
        "XF86AudioLowerVolume".action.spawn = [ "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1-" ];
        "XF86AudioMute".action.spawn = [ "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle" ];
        "XF86AudioMicMute".action.spawn = [ "wpctl" "set-mute" "@DEFAULT_AUDIO_SOURCE@" "toggle" ];
      };
    };
  };

  # Shell
  home.sessionVariables = {
    EDITOR = "hx";
    BROWSER = "firefox";
    TERMINAL = "kitty";
    MOZ_USE_XINPUT2 = "1";
  };
  programs.fish = {
    enable = true;
    shellAliases = {
      gs = "git status";
      gd = "git diff";
      se = "sudoedit";
      vim = "nvim";

      xdd-vpn-start = "openvpn3 session-start --config /etc/nixos/secrets/xdd-vpn-profile.ovpn";
      xdd-vpn-stop = "openvpn3 session-manage --disconnect --config /etc/nixos/secrets/xdd-vpn-profile.ovpn";

      nix-re = "sudo nixos-rebuild switch --flake /etc/nixos/.#cynixos";
    };
    functions = {
      fish_greeting = "";
    };
    plugins = [
      { name = "fzf-fish"; src = pkgs.fishPlugins.fzf-fish.src; }
    ];
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

  # SSH
  programs.ssh = {
    enable = true;

    matchBlocks = {
      "github.com" = {
        hostname = "github.com";
        user = "git";
        identityFile = "~/.ssh/id_github";
        identitiesOnly = true;
      };
    };
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
    };
  };
  
  # Terminal
  programs.kitty = {
    enable = true;

    themeFile = "Nord";

    font = {
      name = "UbuntuMono Nerd Font";
      size = 12;
    };

    settings = {
      scrollback_pager = "${pkgs.moor}/bin/moor";
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
      background_opacity = "0.95";
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
    defaultEditor = true;
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

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    plugins = with pkgs.vimPlugins; [
      nvim-web-devicons
      telescope-nvim
      plenary-nvim
      nvim-tree-lua
      (nvim-treesitter.withAllGrammars)
      nvim-lspconfig
      nvim-cmp
      cmp-nvim-lsp
      luasnip
      cmp_luasnip
      nvim-jdtls
    ];
    
    extraLuaConfig = ''
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1
      vim.opt.number = true
      vim.opt.shiftwidth = 2
      vim.opt.tabstop = 2
      vim.opt.expandtab = true
      vim.opt.smartindent = true
      vim.opt.clipboard = "unnamedplus"
      vim.opt.splitright = true
      vim.g.mapleader = " "

      -- TELESCOPE (Fuzzy Finder)
      local builtin = require('telescope.builtin')
      vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
      vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
      vim.keymap.set('n', '<leader>fb', builtin.buffers, {})

      -- FILE TREE (Nvim Tree)
      require("nvim-tree").setup({})
      vim.keymap.set('n', '<leader>e', ':NvimTreeToggle<CR>', {})

      -- TREESITTER (Syntax Highlighting)
      require'nvim-treesitter.configs'.setup {
        highlight = { enable = true },
        indent = { enable = true },
      }
      
      -- LSP SETUP (Language Servers)
      vim.lsp.enable('nixd')
      vim.lsp.enable('lua_ls')
      vim.lsp.enable('jdtls')

      -- AUTOCOMPLETE (nvim-cmp)
      local cmp = require'cmp'
      cmp.setup({
        snippet = {
          expand = function(args)
            require('luasnip').lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
        })
      })
    '';
  };

  services.mako = {
    enable = true;

    settings = {
      defaultTimeout = 5000; # 5 seconds
      # Typography
      # font = "JetBrains Mono 12"; # Change to your preferred font
  
      # Colors (RRGGBB or RRGGBBAA for transparency)
      backgroundColor = "#1e1e2ee6"; # Dark with slight transparency
      textColor = "#cdd6f4ff";       # Light text
      borderColor = "#89b4faee";     # Accent border
  
      # Geometry & Layout
      borderRadius = 5;              # Rounded corners
      borderSize = 2;
      padding = "15";                # Internal spacing
      margin = "20";                 # Distance from screen edge
  
      # Optional: Grouping
      groupBy = "summary";
    };
  };

  programs.qutebrowser = {
    enable = true;

    # Essential for Niri/Wayland to prevent blurry XWayland rendering
    package = pkgs.qutebrowser.override {
      enableWideVine = true; # For Netflix/Spotify
    };

    # Basic settings map
    settings = {
      colors.webpage.darkmode.enabled = true;
      content.javascript.clipboard = "access"; # Allow websites to copy to clipboard
      window.hide_decoration = true; # Minimalist look
    };

    # The Power User Config
    extraConfig = ''
      # 1. WAYLAND SPECIFICS
      # Fix clipboard in Wayland
      import os
      os.environ["QT_QPA_PLATFORM"] = "wayland"

      # 2. DEV SEARCH ENGINES
      # Usage: "n python" -> searches nixpkgs for python
      c.url.searchengines = {
        "DEFAULT": "https://duckduckgo.com/?q={}",
        "g":       "https://google.com/search?q={}",
        "n":       "https://search.nixos.org/packages?channel=unstable&query={}",
        "no":      "https://search.nixos.org/options?channel=unstable&query={}",
        "hm":      "https://home-manager-options.extranix.com/?query={}",
        "gh":      "https://github.com/search?q={}",
        "yt":      "https://www.youtube.com/results?search_query={}",
      }

      # 3. DEVELOPER KEYBINDINGS
      # Leader key usually defaults to comma (,)
      config.bind(',d', 'devtools')
      config.bind(',r', 'config-source') # Reload config without restart

      # Quick Localhost Switching
      # usage: ,l -> localhost:3000, ,k -> localhost:8080
      config.bind(',l', 'open -t http://localhost:3000') 
      config.bind(',k', 'open -t http://localhost:8080')
      config.bind(',j', 'open -t http://localhost:8000')

      # 4. YOUTUBE / MEDIA
      # Spawn mpv to watch videos (saves RAM/CPU compared to browser decoding)
      # Requires 'mpv' to be installed in your system
      config.bind(',v', 'spawn mpv {url}')
      config.bind(',V', 'hint links spawn mpv {hint-url}')
    '';
  };

  programs.gh = {
    enable = true;
    extensions = [ pkgs.gh-dash ];
  };

  programs.gh-dash = {
    enable = true;
    settings = {
    };
  };

  xdg.configFile."wtf/config.yml".text = ''
    wtf:
      colors:
        background: "black"
        border:
          focusable: "darkslateblue"
          focused: "orange"
          normal: "gray"
      grid:
        columns: [30, 30, 30, 30]
        rows: [10, 10, 10, 10, 4]
      refreshInterval: 1s

      modules:
        git:
          commitCount: 5
          commitOrder: "date"
          enabled: true
          repositories:
          - "~/path/to/your/repo" # REQUIRED: Add your repo path here
          position:
            top: 0
            left: 0
            height: 2
            width: 2
          refreshInterval: 8s

        weather:
          # Get key from: https://home.openweathermap.org/api_keys
          apiKey: "YOUR_OPENWEATHER_API_KEY"
          cityids:
          - 1566083 # Ho Chi Minh City
          enabled: true
          position:
            top: 0
            left: 2
            height: 2
            width: 1
          refreshInterval: 15m

        todo:
          enabled: true
          filename: "todo.yml"
          position:
            top: 0    # MOVED: Was colliding with Docker at top: 2
            left: 3   # MOVED: Fits in the last column
            height: 2
            width: 1
          refreshInterval: 1h

        docker:
          enabled: true
          position:
            top: 2
            left: 0
            height: 2
            width: 4
          refreshInterval: 1s
          labelColor: "lightblue"

        clocks:
          colors:
            rows:
              even: "lightblue"
              odd: "white"
          enabled: true
          locations:
            New York: "America/New_York"
            Saigon: "Asia/Ho_Chi_Minh"
            Tokyo: "Asia/Tokyo"
          position:
            top: 4
            left: 0
            height: 1
            width: 2
          refreshInterval: 15s
          sort: "alphabetical"

        security:
          enabled: true
          position:
            top: 4
            left: 2
            height: 1
            width: 2
          refreshInterval: 1h
  '';

  programs.chromium = {
    enable = true;
    package = pkgs.brave; # The magic switch
  
    # Niri / Wayland specific optimization flags
    commandLineArgs = [
      "--enable-features=UseOzonePlatform"
      "--ozone-platform=wayland"
      "--enable-wayland-ime" # Enable if you need CJK input method support
    ];

    # Optional: Install extensions declaratively
    # You can find extension IDs in the Chrome Web Store URL
    extensions = [
      { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } # uBlock Origin (Brave shields are good, this is better)
    ];
  };

}
