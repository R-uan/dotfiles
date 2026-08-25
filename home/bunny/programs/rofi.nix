{ config, pkgs, ... }: {
  programs.rofi = {
    enable = true;
    package = pkgs.rofi;
  };

  home.file.".config/rofi" = {
    source = ../config/rofi;
    recursive = true;
  };
}
