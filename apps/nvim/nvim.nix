{ pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    viAlias = false;
    vimAlias = true;

    # Native plugin builds must use Nix's matching compiler, linker and SDK.
    extraWrapperArgs = [ "--set" "CC" "${pkgs.stdenv.cc}/bin/cc" ];

    plugins = with pkgs.vimPlugins; [
      # Keep parsers and their matching Tree-sitter plugin managed together by Nix.
      nvim-treesitter.withAllGrammars
    ];

    # External packages needed for Neovim (LSPs, Formatters)
    extraPackages = with pkgs; [
      git # vim.pack
      gnumake # telescope-fzf-native build hook
      stdenv.cc
      fzf
      fd
      lua-language-server
      nil # Nix LSP
      ripgrep
    ];
  };

  # Link your existing Lua config folder to ~/.config/nvim
  xdg.configFile."nvim" = {
    source = ./nvim0;
    recursive = true;
  };
}
