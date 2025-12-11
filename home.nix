{ config, pkgs, inputs, ... }:

{
  home.stateVersion = "25.05";

  imports = [
    inputs.niri.homeModules.niri
  ];

  home.packages = with pkgs; [
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

    # apps
    slack
    telegram-desktop
    zed-editor
  ];

  # Niri - desktop
  programs.niri = {
    enable = true;

    settings = {
      layout = {
        gaps = 16;
      };

      spawn-at-startup = [
        { command = ["xwayland-satellite"]; }
      ];

      binds = with config.lib.niri.actions; {
        # -- Apps --
        "Mod+E".action.spawn = "kitty";
        "Mod+D".action.spawn = "fuzzel";
        "Mod+Shift+W".action.spawn = "waybar";

        # -- Window Management --
        "Mod+Q".action.close-window = [];
        "Mod+Shift+E".action.quit = { skip-confirmation = true; };

        # -- Focus (Vim keys + Arrows) --
        "Mod+Left".action.focus-column-left = [];
        "Mod+Down".action.focus-window-down = [];
        "Mod+Up".action.focus-window-up = [];
        "Mod+Right".action.focus-column-right = [];
        "Mod+H".action.focus-column-left = [];
        "Mod+J".action.focus-window-down = [];
        "Mod+K".action.focus-window-up = [];
        "Mod+L".action.focus-column-right = [];

        # -- Moving Windows --
        "Mod+Ctrl+Left".action.move-column-left = [];
        "Mod+Ctrl+Down".action.move-window-down = [];
        "Mod+Ctrl+Up".action.move-window-up = [];
        "Mod+Ctrl+Right".action.move-column-right = [];
        "Mod+Ctrl+H".action.move-column-left = [];
        "Mod+Ctrl+J".action.move-window-down = [];
        "Mod+Ctrl+K".action.move-window-up = [];
        "Mod+Ctrl+L".action.move-column-right = [];

        # -- Monitor Focus --
        "Mod+Shift+Left".action.focus-monitor-left = [];
        "Mod+Shift+Down".action.focus-monitor-down = [];
        "Mod+Shift+Up".action.focus-monitor-up = [];
        "Mod+Shift+Right".action.focus-monitor-right = [];

        # -- Window Resizing --
        "Mod+Minus".action.set-column-width = "-10%";
        "Mod+Equal".action.set-column-width = "+10%";
        "Mod+Shift+Minus".action.set-window-height = "-10%";
        "Mod+Shift+Equal".action.set-window-height = "+10%";

        # -- Snapshots --
        "Print".action.screenshot = [];
        "Ctrl+Print".action.screenshot-screen = [];
        "Alt+Print".action.screenshot-window = [];

        # -- Audio --
        "XF86AudioRaiseVolume".action.spawn = ["wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1+"];
        "XF86AudioLowerVolume".action.spawn = ["wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1-"];
        "XF86AudioMute".action.spawn = ["wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle"];

      };
    };
  };

  # Shell
  home.sessionVariables = {
    EDITOR = "vim";
    BROWSER = "firefox";
    TERMINAL = "kitty";
  };
  programs.fish = {
    enable = true;
    shellAliases = {
      gs = "git status";
      gd = "git diff";
      se = "sudoedit";
      vim = "nvim";

      xdd-vpn-start = "sudo openvpn3 session-start --config /etc/nixos/secrets/xdd-vpn-profile.ovpn && openvpn3 session-auth";
      xdd-vpn-stop = "sudo openvpn3 session-manage --disconnect --config /etc/nixos/secrets/xdd-vpn-profile.ovpn";

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
    extraConfig = {
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

    # font = {
    #   # name = "";
    #   size = 12;
    # };

    settings = {
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

  # Neovim
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
}
