{
  config,
  pkgs,
  ...
}: {
  imports = [
    ../../modules/services/sddm.nix
    ../../modules/services/nbfc.nix
    ./hardware-configuration.nix
  ];

  system.stateVersion = "25.05"; # Did you read the comment?

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nix.settings.experimental-features = ["nix-command" "flakes"];
  programs.nix-ld.enable = true;

  # ------ NETWORK ------

  networking = {
    hostName = "ruan-nixos";
    networkmanager.enable = true;
  };

  networking.hosts = {
    "127.0.0.1" = ["www.apoioteste.sitemidas" "apoioteste.sitemidas" "www.site17.sitemidas" "painelteste.sitemidas" "www.site10.sitemidas" "site10.sitemidas"];
  };

  # ------ LOCALE ------

  time.timeZone = "America/Bahia";

  console.keyMap = "br-abnt2";

  services.xserver.xkb = {
    layout = "br";
    variant = "nodeadkeys";
  };

  i18n = {
    defaultLocale = "en_GB.UTF-8";
    extraLocaleSettings = {
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
    inputMethod = {
      enabled = "fcitx5";
      fcitx5.addons = with pkgs; [
        fcitx5-gtk
        qt6Packages.fcitx5-chinese-addons
        libsForQt5.fcitx5-qt
        kdePackages.fcitx5-configtool
      ];
    };
  };

  # ------ AUDIO ------
  security.rtkit.enable = true;
  services.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    alsa.support32Bit = true;
  };

  # ------ VIDEO ------
  services.xserver.enable = true;
  services.displayManager.defaultSession = "hyprland";

  users.users.bunny = {
    isNormalUser = true;
    shell = pkgs.zsh;
    ignoreShellProgramCheck = true;
    extraGroups = ["networkmanager" "wheel" "docker"];
  };

  nixpkgs.config.allowUnfree = true;

  # Display Nvidia/Intel

  services.xserver.videoDrivers = ["nvidia"];

  hardware = {
    nvidia = {
      open = false;
      nvidiaSettings = true;
      modesetting.enable = true;
      powerManagement.enable = false;
      package = config.boot.kernelPackages.nvidiaPackages.stable;

      prime = {
        sync.enable = true;
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };

    graphics = {
      enable = true;
      enable32Bit = true; # Critical for Steam
    };
  };

  # Other Hardware

  hardware.bluetooth.enable = true;
  hardware.enableAllFirmware = true;

  # Programs

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  programs.hyprland.enable = true; # window manager

  environment.systemPackages = with pkgs; [
    git
    wget
    curl
  ];

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
}
