# Desktop: Ryzen 5 7600 (iGPU) + MSI PRO B840M-P WiFi6E
# Ao instalar uma Radeon dedicada nada muda aqui: o amdgpu cobre iGPU e dGPU.
{...}: {
  imports = [
    ./hardware-configuration.nix
    ../../modules/common/default.nix
    ../../modules/desktop/default.nix
    ../../modules/hardware/amd.nix
  ];

  networking.hostName = "bunny-nixos";

  system.stateVersion = "26.05"; # Did you read the comment?
}
