{ config, pkgs, ... }:
{
  imports = [
    ../../modules/services/nbfc.nix
    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nix.settings.experimental-features = ["nix-command" "flakes"];

  networking.hostName = "ruan-nixos";
  networking.networkmanager.enable = true;

  time.timeZone = "America/Bahia";
  i18n.defaultLocale = "en_GB.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pt_BR.UTF-8";
    LC_IDENTIFICATION = "pt_BR.UTF-8";
    LC_MEASUREMENT = "pt_BR.UTF-8";
    LC_MONETARY = "pt_BR.UTF-8";
    LC_NAME = "pt_BR.UTF-8";
    LC_NUMERIC = "pt_BR.UTF-8";
    LC_PAPER = "pt_BR.UTF-8";
    LC_TELEPHONE = "pt_BR.UTF-8";
    LC_TIME = "pt_BR.UTF-8";
  };

  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.displayManager.defaultSession = "hyprland";


  console.keyMap = "br-abnt2";
  services.xserver.xkb = {
    layout = "br";
    variant = "nodeadkeys";
  };

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    alsa.support32Bit = true;
  };

  users.users.bunny = {
    isNormalUser = true;
    shell = pkgs.zsh;
    ignoreShellProgramCheck = true;
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      kdePackages.kate
    #  thunderbird
    ];
  };

  nixpkgs.config.allowUnfree = true;

  # Display Nvidia/Intel

  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    open = false;
    nvidiaSettings = true;
    modesetting.enable = true;
    powerManagement.enable = false;
    package = config.boot.kernelPackages.nvidiaPackages.stable;

    prime = {
      # offload = {
      #  enable = true;
      #  enableOffloadCmd = true; # Lets you use `nvidia-offload %command%` in steam
      # };

      sync.enable = true;
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;  # Critical for Steam
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  programs.yazi.enable = true;
  programs.firefox.enable = true;
  programs.hyprland.enable = true;

  environment.systemPackages = with pkgs; [
    git
    wget
    curl
  ];

  hardware.enableAllFirmware = true;
  fileSystems."/mnt/hdd" = {
    device = "/dev/disk/by-uuid/5af9c46f-3e7b-4f9a-a7bb-c4864b82f781";
    fsType = "ext4";
    options = [ "defaults" ];
  };

  fileSystems."/mnt/ssd" = {
    device = "/dev/disk/by-uuid/9ee1328e-249b-413e-922d-a30872f6d770";
    fsType = "ext4";
    options = [ "defaults" ];
  };

  hardware.bluetooth.enable = true;
  system.stateVersion = "25.05"; # Did you read the comment?
}
