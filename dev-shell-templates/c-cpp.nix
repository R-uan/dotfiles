{
  description = "C/C++ Dev Shell";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      pkgs = import nixpkgs { system = "x86_64-linux"; };
    in {
      devShells.x86_64-linux.default = pkgs.mkShell {
        buildInputs = [
          pkgs.gdb
          pkgs.gcc
          pkgs.cmake
          pkgs.ninja
          pkgs.pkg-config
          pkgs.clang-tools  # clangd, clang-tidy, clang-format
        ];

        shellHook = ''
          echo "C/C++ shell ready. Don't screw it up."
        '';
      };
    };
}
