# Desktop: Ryzen 5 7600 + Radeon RX 7600 + MSI PRO B840M-P WiFi6E
# O amdgpu cobre a iGPU e a RX 7600, sem config extra.
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
