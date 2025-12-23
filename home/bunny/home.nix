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

  home.packages = with pkgs; [
    # Development Essentials
    ## C/C++ Essentials
    gcc
    lld
    cmake
    ninja
    binutils
    gnumake
    glibc.dev
    pkg-config
    clang-tools

    ## Nix Language
    nil # LSP
    deadnix
    alejandra # Formatter

    ## Lua
    lua
    lua-language-server

    # Terminal Apps
    fd # find replacement
    gawk # text-processing language
    btop # task manager
    procps # for top
    gnused # text surgery
    gnugrep # grep
    ripgrep # text search tool
    bluetuith # bluetooth

    # Desktop Modules
    rofi # App Launcher
    mako # notification displayer

    # Daemons
    networkmanager # network manager
    pulseaudio # audio manager
    libnotify # notifications

    # Other Programs
    vlc # video player
    mpv # media player (for anki audio)
    gimp # Image Editor
    vscode # Code Editor
    vivaldi # browser
    discord # Messaging
    anki-bin # Flashcards
    obsidian # Markdown Notes
    nautilus # file manager
    hyprshot # Screen-capture
    hyprcursor # hyprland cursor
    zed-editor # Code Editor
    dbeaver-bin # Database management
    pavucontrol # PulseAudio control panel
    wineWowPackages.stable # windows app runner

    # Fonts
    iosevka
    nerd-fonts.hack
    nerd-fonts.jetbrains-mono
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    HDD = "/mnt/hdd";
    CODE = "/mnt/hdd/code";
    DTF = "/mnt/hdd/code/dotfiles/";
    #QML2_IMPORT_PATH = "${pkgs.quickshell}/lib/qt-6/qml";
  };

  home.file.".config/btop".source = ./config/btop;
  home.file.".config/mako".source = ./config/mako;
  home.file.".config/hypr".source = ./config/hypr;
  home.file.".local/share/wallpapers".source = ./wallpapers;
  home.file.".config/quickshell".source = ./config/quickshell;

  # Don't change this unless you're rebuilding the system cleanly
  home.stateVersion = "25.05";
}
