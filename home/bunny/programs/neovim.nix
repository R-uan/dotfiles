{
  config,
  pkgs,
  ...
}: {
  programs.neovim = {
    enable = true;
    vimAlias = true;
    package = pkgs.neovim;
  };

  #  home.file.".config/nvim" = {
  #    source = ../config/nvim;
  #    recursive = true;
  #  };
}
