{
  description = "NixOS with Flakes and Home Manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

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

  outputs = { self, nixpkgs, nix-darwin, home-manager, niri, helix, darkvoid-theme, grass-theme, ...}@inputs: {
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
  };
}
