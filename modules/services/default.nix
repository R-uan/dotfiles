{ config, pkgs, ... }: {
  imports = [
    ./sddm.nix
    ./nbfc.nix
  ];
}
