{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../../modules/system/default.nix
    ../../modules/services/default.nix
  ];

  users.users.bunny = {
    shell = pkgs.zsh;
    isNormalUser = true;
    ignoreShellProgramCheck = true;
    extraGroups = ["networkmanager" "wheel" "docker" "i2c"];
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
    kernelModules = ["i2c-dev"];
    initrd.kernelModules = ["nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm"];
    kernelParams = ["nvidia_drm.modeset=1" "nvidia_drm.fbdev=1" "fbcon=map:1"];
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
        "finance.local"

        "painelteste.sitemidas"

        "site26-teste.sitemidas"
        "www.site26-teste.sitemidas"

        "site01.sitemidas"
        "www.site01.sitemidas"
        "site02.sitemidas"
        "www.site02.sitemidas"
        "site03.sitemidas"
        "www.site03.sitemidas"
        "site04.sitemidas"
        "www.site04.sitemidas"
        "site05.sitemidas"
        "www.site05.sitemidas"
        "site06.sitemidas"
        "www.site06.sitemidas"
        "site07.sitemidas"
        "www.site07.sitemidas"
        "site08.sitemidas"
        "www.site08.sitemidas"
        "site09.sitemidas"
        "www.site09.sitemidas"
        "site10.sitemidas"
        "www.site10.sitemidas"
        "site11.sitemidas"
        "www.site11.sitemidas"
        "site12.sitemidas"
        "www.site12.sitemidas"
        "site13.sitemidas"
        "www.site13.sitemidas"
        "site14.sitemidas"
        "www.site14.sitemidas"
        "site15.sitemidas"
        "www.site15.sitemidas"
        "site16.sitemidas"
        "www.site16.sitemidas"
        "site17.sitemidas"
        "www.site17.sitemidas"
        "site18.sitemidas"
        "www.site18.sitemidas"
        "site19.sitemidas"
        "www.site19.sitemidas"
        "site20.sitemidas"
        "www.site20.sitemidas"
        "site21.sitemidas"
        "www.site21.sitemidas"
        "site22.sitemidas"
        "www.site22.sitemidas"
        "site23.sitemidas"
        "www.site23.sitemidas"
        "site24.sitemidas"
        "www.site24.sitemidas"
        "site25.sitemidas"
        "www.site25.sitemidas"
        "site26.sitemidas"
        "www.site26.sitemidas"
        "site27.sitemidas"
        "www.site27.sitemidas"
        "site28.sitemidas"
        "www.site28.sitemidas"
        "site29.sitemidas"
        "www.site29.sitemidas"
        "site30.sitemidas"
        "www.site30.sitemidas"
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

    udev.extraRules = ''
      KERNEL=="i2c-[0-9]*", GROUP="i2c", MODE="0660"
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

    i2c = {
      enable = true;
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

    gamemode = {
      enable = true;
      enableRenice = true;
      settings = {
        general = {
          renice = 10; # how aggressively it boosts process priority
        };
      };
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
    ddcutil
    appimage-run
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

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (pkgs.lib.getName pkg) [
      "cloudflare-warp"
    ];

  systemd.services.warp-svc = {
    description = "Cloudflare WARP daemon";
    wantedBy = ["multi-user.target"];
    after = ["network-online.target"];
    wants = ["network-online.target"];

    serviceConfig = {
      ExecStart = "${pkgs.cloudflare-warp}/bin/warp-svc";
      Restart = "always";
      RestartSec = 5;
    };
  };
}
