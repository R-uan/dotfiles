{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./programs/default.nix
  ];

  home.username = "bunny";
  home.homeDirectory = "/home/bunny";

  home.pointerCursor = {
    size = 24;
    gtk.enable = true;
    x11.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
  };

  home.packages = with pkgs; [
    # Programming Related Packages
    ## Nix
    nil       # Language Server
    deadnix   # I don't know, I think it's a linter
    alejandra # Code Formatter

    ## Lua Language
    lua-language-server # Language Server
    (lua52Packages.lua.withPackages ( ps: with ps; [luafilesystem] ))                  

    ## AI agents
    opencode    # Open Source AI Agent (Deepseek)
    claude-code # Claude

    ## Development Tools

    php
    bruno       # API Client
    nodejs
    chromium    # For testing web apps
    phpactor    # PHP Language Server
    dbeaver-bin # Database Manager

    ## Code Editors
    zed-editor
    vscode-fhs

    # Command Line Interface Tools

    fd        # Find replacement
    mtr       # Internet Test
    fzf       # Fuzzy Finder
    zoxide    # Smarter CD
    eza       # Smarter LS
    zip       # Zipper
    unar      # Unziper
    gawk      # Text Processing Language
    btop      # Task Manager
    procps    # For Top
    gnused    # Text Surgery
    gnugrep   # GREP
    ripgrep   # Text Search Tool
    inetutils # Net Utils

    # Terminal User Interface
    yazi        # File Manager
    bluetuith   # Bluetooth Terminal User Interface
    lazydocker  # Docker Terminal User Interface

    # System Utilities
    awww                # Wallpaper Daemon for Wayland
    mako                # Notification
    rofi                # App Launcher
    dxvk                # Not sure what this is
    wtype               # Types Ctrl+V when pasting from the clipboard panel
    slurp               # Region picker for recordings
    vicinae             # App Launcher
    cliphist            # Clipboard history (quickshell clipboard panel)
    hyprshot            # Screenshots
    libnotify           # Notifications Manager ?
    quickshell          # Desktop Widgets
    wf-recorder         # Screen recorder (quickshell recorder)
    imagemagick         # Wallpaper picker thumbnails
    pavucontrol         # PulseAudio Control User Interface
    wl-clipboard        # wl-copy / wl-paste, feeds cliphist
    cloudflare-warp     # Cloudflare VPN (Not really a VPN, used to get better routes for FFXIV)
    papirus-icon-theme  # Icon theme (rofi/GTK app icons)

    # Gaming Related Packages
    mangohud    # Overlay to monitor FPS, temperatures, CPU/GPU
    winetricks  # Essential Extension for Wine
    xivlauncher # XIV Dalamund (Can't play without this)
    (wineWow64Packages.staging.override {
      vulkanSupport = true;
    })          # Windows Compatibility Layer

    vlc         # Media Player
    spotify     # It's spotify
    vesktop     # Alternative Discord Client
    obs-studio  # Screen Recording
    thunderbird # Email Client
    telegram-desktop

    # Fonts
    iosevka
    noto-fonts-cjk-serif # I think this is for chinese characters
    nerd-fonts.jetbrains-mono

    # Packages on unstable channel for separate updating
    inputs.nixpkgs-unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system}.siyuan # Personal Notes (Obsidian Replacement)
  ];
  services.hyprsunset.enable = true;
  home.sessionVariables = {
    EDITOR = "nvim";
    HDD = "/mnt/hdd";
    CODE = "/mnt/hdd/home/code";
    DOTFILES = "/home/bunny/dotfiles/";
  };

  xdg.configFile = {
    nvim = {
      source = ./config/nvim;
      recursive = true;
    };
    hypr = {
      source = ./config/hypr;
      recursive = true;
    };
  };

  home.file.".config/btop".source = ./config/btop;
  home.file.".config/mako".source = ./config/mako;
  home.file.".config/yazi".source = ./config/yazi;
  home.file.".config/quickshell".source = ./config/quickshell;

  # Don't change this unless you're rebuilding the system cleanly
  home.stateVersion = "25.05";
}
