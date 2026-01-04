{
  config,
  pkgs,
  ...
}: {
  imports = [
    ../../modules/services/nbfc.nix
    ./hardware-configuration.nix
  ];

  system.stateVersion = "25.05"; # Did you read the comment?

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nix.settings.experimental-features = ["nix-command" "flakes"];
  programs.nix-ld.enable = true;

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
    extraGroups = ["networkmanager" "wheel" "docker"];
    packages = with pkgs; [
      kdePackages.kate
      #  thunderbird
    ];
  };

  nixpkgs.config.allowUnfree = true;

  # Display Nvidia/Intel

  services.xserver.videoDrivers = ["nvidia"];
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
    enable32Bit = true; # Critical for Steam
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
    options = ["defaults"];
  };

  fileSystems."/mnt/ssd" = {
    device = "/dev/disk/by-uuid/9ee1328e-249b-413e-922d-a30872f6d770";
    fsType = "ext4";
    options = ["defaults"];
  };

  virtualisation.docker = {
    enable = true;
    extraOptions = "--data-root=/mnt/hdd/docker";
    rootless = {
      enable = true;
      setSocketVariable = true;

      daemon.settings = {
        dns = ["1.1.1.1" "8.8.8.8"];
        registry-mirrors = ["https://mirror.gcr.io"];
      };
    };
  };

  systemd.services.docker.serviceConfig = {
    MemoryMax = "4G";
    CPUQuota = "200%";
  };

  hardware.bluetooth.enable = true;
  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

      CPU_MIN_PERF_ON_AC = 0;
      CPU_MAX_PERF_ON_AC = 100;
      CPU_MIN_PERF_ON_BAT = 0;
      CPU_MAX_PERF_ON_BAT = 20;

      #Optional helps save long term battery health
      START_CHARGE_THRESH_BAT0 = 40; # 40 and below it starts to charge
      STOP_CHARGE_THRESH_BAT0 = 70; # 70 and above it stops charging
    };
  };
  services.flatpak.enable = true;
  services.mpd = {
    enable = true;
    musicDirectory = "/mnt/hdd/home/Music/";
    extraConfig = ''
      audio_output {
        type "pipewire"
        name "My PipeWire Output"
      }'';
  };
}
