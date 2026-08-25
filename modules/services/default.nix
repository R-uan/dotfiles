{ config, pkgs, ... }: {
  imports = [
    ./nbfc.nix
    ./greetd.nix
  ];
}
