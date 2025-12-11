{
  description = "NixOS with Flakes and Home Manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    niri.url = "github:sodiboo/niri-flake";
  };
  outputs = { self, nixpkgs, home-manager, niri, ...}@inputs: {
    nixosConfigurations = {
      cynixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./configuration.nix
          # ./vpn.nix
          {
            nixpkgs.overlays = [ niri.overlays.niri ];
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
