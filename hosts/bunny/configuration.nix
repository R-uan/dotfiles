{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../../modules/services/sddm.nix
    ../../modules/services/nbfc.nix
  ];

  users.users.bunny = {
    shell = pkgs.zsh;
    isNormalUser = true;
    ignoreShellProgramCheck = true;
    extraGroups = ["networkmanager" "wheel" "docker"];
  };

  time.timeZone = "America/Bahia";
  console.keyMap = "br-abnt2";

  security.rtkit.enable = true;
  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "25.05"; # Did you read the comment?

  nix = {
    settings.experimental-features = ["nix-command" "flakes"];
    gc = {
      automatic = true;
      dates = "weekly"; # or "daily"
      options = "--delete-older-than 7d";
    };
  };

  boot = {
    loader = {
      efi = {canTouchEfiVariables = true;};

      systemd-boot = {
        enable = true;
        configurationLimit = 5;
      };
    };
  };

  networking = {
    hostName = "ruan-nixos";
    networkmanager = {enable = true;};
    resolvconf.useLocalResolver = false;

    nameservers = [
      "1.1.1.1"
      "8.8.8.8"
    ];

    hosts = {
      "127.0.0.1" = [
        "www.apoioteste.sitemidas"
        "apoioteste.sitemidas"
        "painelteste.sitemidas"
        "www.site27.sitemidas"
        "www.site10.sitemidas"
        "site10.sitemidas"
        "site27.sitemidas"
      ];
    };
  };

  services = {
    xserver.xkb = {
      layout = "br";
      variant = "nodeadkeys";
    };

    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
      alsa.support32Bit = true;
    };

    xserver = {
      enable = true;
      videoDrivers = ["nvidia"];
    };

    resolved = {enable = true;};
    pulseaudio = {enable = false;};
    displayManager = {defaultSession = "hyprland";};
    flatpak = {enable = true;};

    udev.extraHwdb = ''
      evdev:input:b0003v36B7pFD13*
        KEYBOARD_KEY_7001e=kp1
        KEYBOARD_KEY_7001f=kp2
        KEYBOARD_KEY_70020=kp3
        KEYBOARD_KEY_70021=kp4
        KEYBOARD_KEY_70022=kp5
        KEYBOARD_KEY_70023=kp6
        KEYBOARD_KEY_70024=kp7
        KEYBOARD_KEY_70025=kp8
        KEYBOARD_KEY_70026=kp9
        KEYBOARD_KEY_70027=kp0
        KEYBOARD_KEY_70057=kpplus
        KEYBOARD_KEY_70056=kpminus
    '';
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
      enable = true;
      type = "fcitx5";
      fcitx5.addons = with pkgs; [
        fcitx5-gtk
        qt6Packages.fcitx5-chinese-addons
        libsForQt5.fcitx5-qt
        kdePackages.fcitx5-configtool
      ];
    };
  };

  hardware = {
    nvidia = {
      open = false;
      branch = "legacy_580";
      nvidiaSettings = true;
      modesetting.enable = true;
      powerManagement.enable = false;

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

    enableAllFirmware = true;
    bluetooth = {enable = true;};
    opentabletdriver = {enable = true;};
  };

  programs = {
    nix-ld = {enable = true;};
    hyprland = {enable = true;};

    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };
  };

  # configuration.nix
  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-hyprland
    ];

    config.hyprland = {
      default = ["gtk"];
      "org.freedesktop.impl.portal.FileChooser" = ["gtk"];
    };
  };

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
