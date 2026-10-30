{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./common.nix
    ./programs/rofi.nix
    ./programs/kitty.nix
    ./programs/hyprlock.nix
    ./programs/hypridle.nix
  ];

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
    opencode
    claude-code

    ## Development Tools
    php
    bruno       # API Client
    nodejs
    phpactor    # PHP Language Server
    dbeaver-bin # Database Manager
    ## Code Editors
    zed-editor
    vscode-fhs

    # Terminal User Interface
    bluetuith   # Bluetooth Terminal User Interface

    # System Utilities
    awww                # Wallpaper Daemon for Wayland
    mako                # Notification
    vicinae             # App Launcher
    rofi                # App Launcher
    papirus-icon-theme  # Icon theme (rofi/GTK app icons)
    dxvk                # Not sure what this is
    libnotify           # Notifications Manager ?
    hyprshot            # Screenshots
    pavucontrol         # PulseAudio Control User Interface
    cloudflare-warp     # Cloudflare VPN (Not really a VPN, used to get better routes for FFXIV)
    quickshell
    #(inputs.quickshell.packages.${pkgs.stdenv.hostPlatform.system}.default.override {
    #  withX11 = false;
    #  withWayland = true;
    #  withPipewire = true;
    #  withHyprland = true;
    #})                  # Desktop Widgets
    # Gaming Related Packages
    mangohud    # Overlay to monitor FPS, temperatures, CPU/GPU
    winetricks  # Essential Extension for Wine
    xivlauncher # XIV Dalamund (Can't play without this)
    (wineWow64Packages.staging.override {
      vulkanSupport = true;
    })          # Windows Compatibility Layer

    chromium
    obs-studio
    thunderbird
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default

    vlc     # Media Player
    dorion  # Tiny discord client alternative
    spotify # It's spotify
    vesktop # Alternative Discord Client
    telegram-desktop
    proton-vpn
    # Fonts
    iosevka
    noto-fonts-cjk-serif # I think this is for chinese characters
    nerd-fonts.jetbrains-mono

    # Packages on unstable channel for separate updating
    inputs.nixpkgs-unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system}.siyuan # Personal Notes (Obsidian Replacement)
  ];

  home.sessionVariables = {
    HDD = "/mnt/hdd";
    CODE = "/mnt/hdd/home/code";
  };

  xdg.configFile.hypr = {
    source = ./config/hypr;
    recursive = true;
  };

  home.file.".config/mako".source = ./config/mako;
  home.file.".config/quickshell".source = ./config/quickshell;
}
