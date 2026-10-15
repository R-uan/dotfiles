# Notebook Acer Nitro AN515-51 (i5-7300HQ + GTX 1050 Mobile) como home-server
{...}: {
  imports = [
    ./hardware-configuration.nix
    ../../modules/common/default.nix
    ../../modules/server/default.nix
    ../../modules/server/nbfc.nix
  ];

  networking.hostName = "bunny-home-server";

  # Funciona com a tampa fechada
  services.logind.settings.Login = {
    HandleLidSwitch = "ignore";
    HandleLidSwitchExternalPower = "ignore";
    HandleLidSwitchDocked = "ignore";
  };

  # Apaga a tela interna após 1 min sem uso
  boot.kernelParams = ["consoleblank=60"];

  # GTX 1050 sem uso: remove do barramento PCI para economizar energia e calor
  boot.blacklistedKernelModules = ["nouveau"];
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{remove}="1"
  '';

  virtualisation.docker.extraOptions = "--data-root=/mnt/hdd/docker";

  system.stateVersion = "25.05"; # Did you read the comment?
}
