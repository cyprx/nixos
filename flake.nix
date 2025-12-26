{
  description = "NixOS with Flakes and Home Manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
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
  };

  outputs = { self, nixpkgs, home-manager, niri, helix, darkvoid-theme, ...}@inputs: {
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
              (import ./overlays/slack.nix)
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
  };
}
