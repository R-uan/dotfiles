# Desktop (Ryzen 5 7600 + RX 7600). Módulos via `nixos-generate-config --show-hardware-config`;
# discos por UUID (as partições não têm label, então by-label não monta).
{ config, lib, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" "uas" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/fb930239-89d8-47e0-9b29-5babdc5be6d2";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/1681-CE6D";
    fsType = "vfat";
    options = [ "fmask=0077" "dmask=0077" ];
  };

  fileSystems."/mnt/hdd" = {
    device = "/dev/disk/by-uuid/5af9c46f-3e7b-4f9a-a7bb-c4864b82f781";
    fsType = "ext4";
    options = [ "defaults" "nofail" ];
  };

  fileSystems."/mnt/ssd" = {
    device = "/dev/disk/by-uuid/40e040e8-92dc-4039-997c-423a0dfc5c45";
    fsType = "ext4";
    options = [ "defaults" "nofail" ];
  };

  swapDevices = [
    { device = "/dev/disk/by-uuid/5a9ae632-8221-4019-9634-faf3d557818c"; }
  ];

  networking.useDHCP = lib.mkDefault true;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
