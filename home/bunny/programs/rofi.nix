{ config, pkgs, ... }: {
  programs.rofi = {
    enable = true;
    package = pkgs.rofi;
    extraConfig = {
    font = "JetBrainsMono Nerd Font 14";
    show-icons = true;
    display-window = "Window";
    display-drun = "Search";
    };
  };

  home.file.".config/rofi" = {
    source = ../config/rofi;
    recursive = true;
  };
}
