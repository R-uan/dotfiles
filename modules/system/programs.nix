{pkgs, ...}: {
  programs.nix-ld.enable = true;
  services.flatpak.enable = true;

  environment.systemPackages = with pkgs; [
    git
    wget
    curl
    ddcutil
    appimage-run
  ];
}
