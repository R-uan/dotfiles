{pkgs, ...}: {
  services.xserver = {
    enable = true;
    videoDrivers = ["nvidia"];
  };

  programs.hyprland.enable = true;
  services.displayManager.defaultSession = "hyprland";

  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-hyprland
    ];

    config.hyprland = {
      default = ["gtk"];
      "org.freedesktop.impl.portal.FileChooser" = ["gtk"];
    };
  };
}
