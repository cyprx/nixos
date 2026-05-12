{
  description = "NixOS with Flakes and Home Manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Nix-Darwin
    nix-darwin.url = "github:LnL7/nix-darwin";
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
  };

  outputs = { self, nixpkgs, nix-darwin, nixos-wsl, home-manager, niri, helix, darkvoid-theme, grass-theme, ...}@inputs:
  let
          forAllSystems = nixpkgs.lib.genAttrs [ "x86_64-linux" "aarch64-darwin" ];
  in
  {
    nixosConfigurations = {
      cynixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./configuration.nix
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
            home-manager.extraSpecialArgs = { inherit inputs; };
            home-manager.users.cyprx = import ./home.nix;
          }
        ];
      };
    };

    darwinConfigurations = {
      cymacos = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/mac
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "bk";
            home-manager.extraSpecialArgs = { inherit inputs; };
            home-manager.users.cyprx = import ./home/darwin.nix;
          }
        ];
      };
    };

    nixosConfigurations = {
      cywsl = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
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
            home-manager.extraSpecialArgs = { inherit inputs; };
            home-manager.users.cyprx = import ./home/wsl.nix;
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
    });
  };
}
