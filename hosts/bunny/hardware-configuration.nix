# PLACEHOLDER — substituir pelo arquivo gerado na instalação:
#   nixos-generate-config --root /mnt --show-hardware-config > hosts/desktop/hardware-configuration.nix
# Até lá usa labels de partição (rotular como "nixos" e "boot" ao formatar).
{ config, lib, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/boot";
    fsType = "vfat";
    options = [ "fmask=0077" "dmask=0077" ];
  };

  # HDD SATA secundário, se for reaproveitado (conferir o UUID com `blkid`)
  # fileSystems."/mnt/hdd" = {
  #   device = "/dev/disk/by-uuid/5af9c46f-3e7b-4f9a-a7bb-c4864b82f781";
  #   fsType = "ext4";
  #   options = ["defaults" "nofail"];
  # };

  networking.useDHCP = lib.mkDefault true;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
