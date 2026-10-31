{
  description = "Bunny NixOS";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
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

    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
  };

  outputs = inputs @ {self, ...}: let
    system = "x86_64-linux";
    pkgs = import inputs.nixpkgs {
      inherit system;

      overlays = [
        inputs.neovim-nightly-overlay.overlays.default
      ];
    };
    helpers = import ./lib { inherit pkgs; lib = inputs.nixpkgs.lib; };

    # Cada host vive em ./hosts/<name> e escolhe seu perfil do home-manager
    mkHost = name: home: inputs.nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {inherit inputs helpers;};

      modules = [
        {
          nixpkgs.overlays = [
            inputs.neovim-nightly-overlay.overlays.default
          ];
        }
        ./hosts/${name}/configuration.nix

        inputs.home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "hm-backup";
          home-manager.extraSpecialArgs = { inherit inputs helpers; };
          home-manager.users.bunny = import home;
        }

        ({ pkgs, helpers, ... }: {
          environment.systemPackages = [
            (helpers.mkRebuildScript name)
          ];
        })
      ];
    };
  in {
    nixosConfigurations = {
      bunny = mkHost "bunny" ./home/bunny/desktop.nix;   # Desktop Ryzen 5 7600 + Radeon
      server = mkHost "server" ./home/bunny/server.nix;  # Notebook Acer Nitro (home-server)
    };
  };
}
