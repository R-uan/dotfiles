# Base compartilhada por todas as máquinas
{...}: {
  imports = [
    ./nix.nix
    ./users.nix
    ./boot.nix
    ./locale.nix
    ./networking.nix
    ./virtualisation.nix
    ./programs.nix
  ];

  hardware.enableAllFirmware = true;
}
