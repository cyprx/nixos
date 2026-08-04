{
  description = "NixOS with Flakes and Home Manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Nix-Darwin
    # Use `github:nix-darwin/nix-darwin/nix-darwin-25.11` to use Nixpkgs 25.11.
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    # Nix-WSL
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    niri.url = "github:sodiboo/niri-flake";
    helix.url = "github:helix-editor/helix";
    darkvoid-theme = {
      url = "github:cyprx/darkvoid-helix";
      flake = false;
    };
    grass-theme = {
      url = "github:cyprx/grass-helix";
      flake = false;
    };
    alabaster-theme = {
      url = "github:wolf/alabaster-for-helix";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, nix-darwin, nixos-wsl, home-manager, niri, helix, darkvoid-theme, grass-theme, alabaster-theme, ...}@inputs:
  let
          forAllSystems = nixpkgs.lib.genAttrs [ "x86_64-linux" "aarch64-darwin" ];
          identity = import ./identity.nix;
  in
  {
    nixosConfigurations = {
      cynixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; user = identity.cynixos; };
        modules = [
          ./hosts/nixos
          # ./vpn.nix
          {
            nixpkgs.overlays = [
              niri.overlays.niri
              (final: prev: {
                  niri = prev.niri.overrideAttrs (old: {
                  doCheck = false;
                });
              })
              (import ./overlays/slack.nix)
              (import ./overlays/claude.nix)
            ];
          }

          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "bk";
            home-manager.extraSpecialArgs = { inherit inputs; user = identity.cynixos; };
            home-manager.users.${identity.cynixos.username} = import ./home/nixos.nix;
          }
        ];
      };
    };

    darwinConfigurations = {
      cymacos = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        specialArgs = { inherit inputs; user = identity.cymacos; };
        modules = [
          ./hosts/mac
          { nixpkgs.config.allowUnfree = true; }
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "bk";
            home-manager.extraSpecialArgs = { inherit inputs; user = identity.cymacos; };
            home-manager.users.${identity.cymacos.username} = import ./home/darwin.nix;
          }
        ];
      };
    };

    nixosConfigurations = {
      cywsl = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; user = identity.cywsl; };
        modules = [
          ./hosts/wsl
          nixos-wsl.nixosModules.default
          {
            system.stateVersion = "25.05";
            wsl.enable = true;
          }
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "bk";
            home-manager.extraSpecialArgs = { inherit inputs; user = identity.cywsl; };
            home-manager.users.${identity.cywsl.username} = import ./home/wsl.nix;
          }
        ];
      };
    };

    devShells = forAllSystems (system: {
        node-dev = let
          pkgs = nixpkgs.legacyPackages.${system};
        in pkgs.mkShell {
          buildInputs = with pkgs; [
            nodejs_22
            nodePackages.npm
            nodePackages.pnpm
            nodePackages.typescript-language-server
          ];

          shellHook = ''
            export NPM_CONFIG_USERCONFIG="$PWD/.npmrc"
            echo "Node.js $(node --version)"
            echo "npm $(npm --version)"
            echo "pnpm $(pnpm --version)"
          '';
        };

        dotnet-dev = let
          pkgs = nixpkgs.legacyPackages.${system};
        in pkgs.mkShell {
          buildInputs = with pkgs; [
              dotnet-sdk_10
              csharpier
          ];

          shellHook = ''
            export DOTNET_CLI_TELEMETRY_OPTOUT=1
            echo "🚀 Shared .NET Development Environment Loaded!"
          '';
        };

        rust-dev = let
          pkgs = nixpkgs.legacyPackages.${system};
        in pkgs.mkShell {
          buildInputs = with pkgs; [
            cargo
            rustc
            clippy
            rust-analyzer
            nodejs_22
            deno
          ] ++ pkgs.lib.optionals pkgs.stdenv.isDarwin [
            libiconv
          ];

          RUST_SRC_PATH = "${pkgs.rustPlatform.rustLibSrc}";

          shellHook = ''
            export DOTNET_CLI_TELEMETRY_OPTOUT=1
            echo "🚀 Shared Rust & .NET Development Environment Loaded!"
          '';
        };
    });
  };
}
