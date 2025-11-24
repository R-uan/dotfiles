{ config, pkgs, ... }: {
  imports =[
    ./programs/default.nix
  ];

  home.username = "bunny";
  home.homeDirectory = "/home/bunny";

  home.packages = with pkgs; [
    vlc
    lua
    gimp
    gawk
    rofi
    btop
    procps      # for top
    gnused
    gnugrep
    discord
    obsidian
    nautilus
    hyprshot
    bluetuith
    pulseaudio  # for pactl
    hyprcursor
    zed-editor
    pavucontrol
    networkmanager
    nerd-fonts.hack
    wineWowPackages.stable
    nerd-fonts.jetbrains-mono
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    HDD = "/mnt/hdd";
    CODE = "/mnt/hdd/Code";
    SG = "/mnt/hdd/Code/soundgasm-playlist && npm run start";
  };

  home.file.".config/btop".source = ./config/btop;
  home.file.".config/hypr".source = ./config/hypr;
  home.file.".local/share/wallpapers".source = ./wallpapers;
  home.file.".config/quickshell".source = ./config/quickshell;
  home.stateVersion = "25.05";
}
