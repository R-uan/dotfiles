{
  description = "Bunny NixOS";

  inputs = {
    # Nixpkgs

    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nbfc-linux = {
      url = "github:nbfc-linux/nbfc-linux";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    awww = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "git+https://codeberg.org/LGFae/awww";
    };

    quickshell = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
    };
  };

  outputs = inputs @ { self, ...}:
    let
      system = "x86_64-linux";
      pkgs = import inputs.nixpkgs { inherit system; };
    in
    {
      nixosConfigurations = {
        bunny = inputs.nixpkgs.lib.nixosSystem {
          inherit system;

          modules = [
            ./modules/services/default.nix
            ./hosts/bunny/configuration.nix

            inputs.home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.bunny = import ./home/bunny/home.nix;
            }

            ({pkgs, ...}: {
              environment.systemPackages = [
                (inputs.awww.packages.${pkgs.system}.awww)
                (inputs.quickshell.packages.${pkgs.system}.default.override {
                  withWayland = true;
                  withX11 = false;
                  withPipewire = true;
                  withHyprland = true;
                })
              ];
            })
          ];
        };
      };
    };
}
