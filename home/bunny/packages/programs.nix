{
  pkgs,
  inputs,
  ...
}: {
  home.packages = with pkgs; [
    vlc         # Media Player
    spotify     # It's spotify
    vesktop     # Alternative Discord Client
    obs-studio  # Screen Recording
    thunderbird # Email Client
    telegram-desktop

    # Gaming
    mangohud    # Overlay to monitor FPS, temperatures, CPU/GPU
    winetricks  # Essential Extension for Wine
    xivlauncher # XIV Dalamund (Can't play without this)
    (wineWow64Packages.staging.override {
      vulkanSupport = true;
    })          # Windows Compatibility Layer

    # Packages on unstable channel for separate updating
    inputs.nixpkgs-unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system}.siyuan # Personal Notes (Obsidian Replacement)
  ];
}
