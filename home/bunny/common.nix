# Ambiente de terminal compartilhado (desktop e server)
{pkgs, ...}: {
  imports = [
    ./programs/zsh.nix
    ./programs/neovim.nix
    ./programs/starship.nix
    ./programs/fastfetch.nix
  ];

  home.username = "bunny";
  home.homeDirectory = "/home/bunny";

  home.packages = with pkgs; [
    # Command Line Interface Tools
    fd        # Find replacement
    mtr       # Internet Test
    fzf       # Fuzzy Finder
    zoxide    # Smarter CD
    eza       # Smarter LS
    zip       # Zipper
    unar      # Unziper
    gawk      # Text Processing Language
    btop      # Task Manager
    procps    # For Top
    gnused    # Text Surgery
    gnugrep   # GREP
    ripgrep   # Text Search Tool
    inetutils # Net Utils

    # Terminal User Interface
    yazi        # File Manager
    lazydocker  # Docker Terminal User Interface
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    DOTFILES = "/home/bunny/dotfiles/";
  };

  xdg.configFile.nvim = {
    source = ./config/nvim;
    recursive = true;
  };

  home.file.".config/btop".source = ./config/btop;
  home.file.".config/yazi".source = ./config/yazi;

  # Don't change this unless you're rebuilding the system cleanly
  home.stateVersion = "25.05";
}
