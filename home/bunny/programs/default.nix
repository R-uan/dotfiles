{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./zsh.nix
    ./rofi.nix
    ./kitty.nix
    ./starship.nix
    ./fastfetch.nix
  ];
}
