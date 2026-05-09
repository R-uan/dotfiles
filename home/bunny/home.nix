{
  config,
  pkgs,
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
    # Development Essentials
    ## C/C++ Essentials
    gcc
    lld
    cmake
    ninja
    gnumake
    binutils
    patchelf
    glibc.dev
    pkg-config
    clang-tools

    ## Nix Language
    nil
    deadnix
    alejandra # Formatter
    ## Lua
    lua
    lua-language-server

    # Terminal Apps
    fd # find replacement
    yazi # file manager
    gawk # text-processing language
    btop # task manager
    unar
    procps # for top
    gnused # text surgery
    gnugrep # grep
    ripgrep # text search tool
    inetutils #net utils
    bluetuith # bluetooth interface

    # Desktop Modules
    rofi # App Launcher
    mako # notification displayer

    # Daemons
    libnotify # notifications
    pulseaudio # audio manager
    networkmanager # network manager

    # Gaming
    winetricks
    xivlauncher
    wineWowPackages.stable # windows app runner

    # Other Programs
    vlc # video player
    dxvk
    krita # Image Editor
    mplayer # media player (for anki)

    chromium
    firefox # browser
    firefox-devedition
    super-productivity
    telegram-desktop

    anki-bin # Flashcards
    obsidian # Markdown Notes
    kdePackages.dolphin # file manager
    hyprshot # screenshots
    vscode-fhs # code editor
    hyprcursor # hyprland cursor
    dbeaver-bin # database management
    pavucontrol # pulseAudio control panel

    (discord.override {withVencord = true;})

    # Fonts
    iosevka
    noto-fonts-cjk-serif
    nerd-fonts.jetbrains-mono
  ];

  home.sessionVariables = {
    EDITOR = "code";
    HDD = "/mnt/hdd";
    CODE = "/mnt/hdd/home/code";
    DOTFILES = "/mnt/hdd/home/dotfiles";
  };

  # home.file.".config/nvim".source = .config/nvim;
  home.file.".config/btop".source = ./config/btop;
  home.file.".config/mako".source = ./config/mako;
  home.file.".config/hypr".source = ./config/hypr;
  home.file.".config/yazi".source = ./config/yazi;
  home.file.".config/quickshell".source = ./config/quickshell;

  # Don't change this unless you're rebuilding the system cleanly
  home.stateVersion = "25.05";
}
