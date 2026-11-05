{ config, pkgs, ... }: {
  programs.rofi = {
    enable = true;
    package = pkgs.rofi;
    # calc: Super+= (qalculate: units, currency, dates) · emoji: Super+.
    plugins = with pkgs; [ rofi-calc rofi-emoji ];
  };

  home.file.".config/rofi" = {
    source = ../config/rofi;
    recursive = true;
  };
}
