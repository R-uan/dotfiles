{ config, pkgs, ... }: {
  imports = [
    ./greetd.nix
    ./nbfc.nix
  ];
}
