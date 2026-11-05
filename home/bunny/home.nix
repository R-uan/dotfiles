{
  pkgs,
  ...
}: {
  imports = [
    ./programs/default.nix
    ./packages/default.nix
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
  # Emoji table for the launcher's ":" mode (emoji, group, subgroup, name, keywords)
  xdg.dataFile."quickshell/emojis.txt".source = "${pkgs.rofi-emoji}/share/rofi-emoji/all_emojis.txt";

  # Don't change this unless you're rebuilding the system cleanly
  home.stateVersion = "25.05";
}
