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
    gtk.enable = true;
    x11.enable = true;
    name = "Bibata-Modern-Classic";
    size = 24;
    package = pkgs.bibata-cursors;
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
    
    # Other Programs
    vlc # video player
    dxvk
    krita # Image Editor
    mplayer # media player (for anki)
    firefox # browser
    anki-bin # Flashcards
    obsidian # Markdown Notes
    nautilus # file manager
    hyprshot # screenshots
    vscode-fhs # code editor
    winetricks 
    hyprcursor # hyprland cursor
    dbeaver-bin # database management
    pavucontrol # pulseAudio control panel
    wineWowPackages.stable # windows app runner
    (discord.override { withVencord = true; })

    # Fonts
    iosevka
    nerd-fonts.hack
    noto-fonts-cjk-serif
    nerd-fonts.jetbrains-mono
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    HDD = "/mnt/hdd";
    CODE = "/mnt/hdd/code";
    DTF = "/mnt/hdd/code/dotfiles/";
    #QML2_IMPORT_PATH = "${pkgs.quickshell}/lib/qt-6/qml";
  };

  # home.file.".config/nvim".source = .config/nvim;
  home.file.".config/btop".source = ./config/btop;
  home.file.".config/mako".source = ./config/mako;
  home.file.".config/hypr".source = ./config/hypr;
  home.file.".config/quickshell".source = ./config/quickshell;

  # Don't change this unless you're rebuilding the system cleanly
  home.stateVersion = "25.05";
}
