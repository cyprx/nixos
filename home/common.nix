{ config, pkgs, inputs, ... }:

{
  home.stateVersion = "25.05";

  home.homeDirectory = 
  if pkgs.stdenv.isDarwin 
  then "/Users/cyprx" 
  else "/home/cyprx";

  home.packages = with pkgs; [
  ];

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
