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
      url = "github:youwen5/zen-browser-flake";
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

    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
  };

  outputs = inputs @ {self, ...}: let
    system = "x86_64-linux";
    dotfilesDir = "/home/bunny/dotfiles";
    pkgs = import inputs.nixpkgs {
      inherit system;

      overlays = [
        inputs.neovim-nightly-overlay.overlays.default
      ];
    };
  in {
    nixosConfigurations = {
      bunny = inputs.nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {inherit inputs;};

        modules = [
          {
            nixpkgs.overlays = [
              inputs.neovim-nightly-overlay.overlays.default
            ];
          }
          ./modules/services/default.nix
          ./hosts/bunny/configuration.nix

          inputs.home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit inputs; };
            home-manager.users.bunny = import ./home/bunny/home.nix;
          }

          ({ pkgs, ... }: {
            environment.systemPackages = [
              (pkgs.writeShellScriptBin "rebuild" ''
                exec nixos-rebuild switch --flake ${dotfilesDir}#bunny "$@"
              '')
            ];
          })
        ];
      };
    };
  };
}
