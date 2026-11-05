{pkgs, ...}: {
  home.packages = with pkgs; [
    # Desktop (Hyprland + quickshell)
    awww                # Wallpaper Daemon for Wayland
    mako                # Notification
    # rofi comes from programs/rofi.nix (wrapped with its plugins)
    libqalculate        # qalc: the launcher's calculator ("=" or just type maths)
    wtype               # Types Ctrl+V when pasting from the clipboard panel
    slurp               # Region picker for recordings
    cliphist            # Clipboard history (quickshell clipboard panel)
    hyprshot            # Screenshots
    hyprsunset          # Night light (started by hyprland.lua, driven by quickshell)
    libnotify           # Notifications Manager ?
    quickshell          # Desktop Widgets
    wf-recorder         # Screen recorder (quickshell recorder)
    imagemagick         # Wallpaper picker thumbnails
    pavucontrol         # PulseAudio Control User Interface
    wl-clipboard        # wl-copy / wl-paste, feeds cliphist
    cloudflare-warp     # Cloudflare VPN (Not really a VPN, used to get better routes for FFXIV)
    papirus-icon-theme  # Icon theme (rofi/GTK app icons)

    # Command Line Interface Tools
    fd        # Find replacement
    mtr       # Internet Test
    fzf       # Fuzzy Finder
    zoxide    # Smarter CD
    zip       # Zipper
    unar      # Unziper
    btop      # Task Manager
    ripgrep   # Text Search Tool
    inetutils # Net Utils

    # Terminal User Interface
    yazi        # File Manager
    bluetuith   # Bluetooth Terminal User Interface
    lazydocker  # Docker Terminal User Interface

    # Fonts
    iosevka
    noto-fonts-cjk-serif # I think this is for chinese characters
    nerd-fonts.jetbrains-mono
  ];
}
