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
    nil # Nix Language Server
    deadnix # Nix I don't know
    alejandra # Nix Code Formatter
    lua-language-server # Lua Language Server
    (lua52Packages.lua.withPackages (
      ps:
        with ps; [luafilesystem]
    )) # Lua Language

    fd # Find replacement
    zip # Zipper
    unar # Unziper
    gawk # Text Processing Language
    btop # Task Manager
    procps # For Top
    gnused # Text Surgery
    gnugrep # GREP
    ripgrep # Text Search Tool
    inetutils # Net Utils

    yazi # File Manager
    bluetuith # Bluetooth Terminal User Interface
    lazydocker # Docker Terminal User Interface

    awww # Wallpaper Daemon for Wayland
    mako # Notification
    rofi # App Launcher
    vicinae # App Launcher
    libnotify # Notifications Manager ?
    (inputs.quickshell.packages.${pkgs.stdenv.hostPlatform.system}.default.override {
      withX11 = false;
      withWayland = true;
      withPipewire = true;
      withHyprland = true;
    }) # Desktop Widgets

    lutris
    winetricks # Essential Extension for Wine
    xivlauncher # XIV Dalamund (Can't play without this)
    osu-lazer-bin # Click the Circles
    (wineWow64Packages.staging.override {
      vulkanSupport = true;
    })

    windsurf # VSCode but with more AI ? (Work Related)
    vscode-fhs # Code Editor

    vlc # Media Player
    dxvk # Not sure what this is
    siyuan # Personal Notes (Obsidian Replacement)
    vivaldi # Browser (It has workspaces so it won)
    vesktop # Alternative Discord Client
    chromium
    hyprshot # Screenshots
    # hyprcursor # Hyprland Cursor (Not sure if its doing anything)
    dbeaver-bin # Database Manager
    pavucontrol # PulseAudio Control User Interface

    claude-code

    # Fonts
    iosevka
    noto-fonts-cjk-serif # I think this is for chinese characters
    nerd-fonts.jetbrains-mono
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    HDD = "/mnt/hdd";
    CODE = "/mnt/hdd/home/code";
    DOTFILES = "/home/bunny/dotfiles/";
  };

  home.file.".config/nvim".source = ./config/nvim;
  home.file.".config/btop".source = ./config/btop;
  home.file.".config/mako".source = ./config/mako;
  home.file.".config/hypr".source = ./config/hypr;
  home.file.".config/yazi".source = ./config/yazi;
  home.file.".config/quickshell".source = ./config/quickshell;

  # Don't change this unless you're rebuilding the system cleanly
  home.stateVersion = "25.05";
}
