{ pkgs, ... }:

let
  sddmThemes = pkgs.callPackage ../../pkgs/sddm-themes.nix { };
  theme = sddmThemes.sddm-themes.r1999_1;
in
{
  environment.systemPackages = [ theme ];

  services.displayManager.sddm = {
    enable = true;
    theme = "R1999_1";
    wayland.enable = true;
    extraPackages = with pkgs.qt6; [
      qtmultimedia
      qt5compat
      theme
    ];
  };
}