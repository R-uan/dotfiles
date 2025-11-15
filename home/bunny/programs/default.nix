{ config, pkgs, ... }: {
  imports = [
    ./zsh.nix
    ./rofi.nix
    ./kitty.nix
    ./neovim.nix
    ./starship.nix
    ./fastfetch.nix
  ];
}
