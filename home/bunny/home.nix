{ config, pkgs, ... }: {
  imports =[
    ./programs/default.nix
  ];

  home.username = "bunny";
  home.homeDirectory = "/home/bunny";

  home.packages = with pkgs; [
    vlc
    rofi
    btop
    discord
    obsidian
    nautilus
    hyprshot
    bluetuith
    hyprcursor
    zed-editor
    networkmanager
    gawk
    gnused
    procps      # for top
    gnugrep
    pulseaudio  # for pactl
    pavucontrol
    nerd-fonts.hack
    nerd-fonts.jetbrains-mono
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    HDD = "/mnt/hdd";
    CODE = "/mnt/hdd/Code";
    SG = "/mnt/hdd/Code/soundgasm-playlist && npm run start";
  };

  home.file.".local/share/wallpapers".source = ./wallpapers;
  home.file.".config/quickshell".source = ./config/quickshell;
  home.stateVersion = "25.05";
}
