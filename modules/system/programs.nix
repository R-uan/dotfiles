{pkgs, ...}: {
  programs.nix-ld.enable = true;
  services.flatpak.enable = true;
  services.logind.lidSwitch = "ignore";

  environment.systemPackages = with pkgs; [
    git
    wget
    curl
    ddcutil
    appimage-run
  ];
}
