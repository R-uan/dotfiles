{
  description = "C/C++ Development Enviroment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    flake-utils,
    nixpkgs,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${stdenv.hostPlatform.system};
    in {
      devShells.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          gdb
          gcc
          cmake
          ninja
          pkg-config
          clang-tools # clangd, clang-tidy, clang-format
        ];
      };
    });
}
