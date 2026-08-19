{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./zsh.nix
    ./rofi.nix
    ./kitty.nix
    ./neovim.nix
    ./starship.nix
    ./hyprlock.nix
    ./hypridle.nix
    ./fastfetch.nix
  ];
}
