{pkgs, ...}: {
  programs.neovim = {
    enable = true;
    vimAlias = true;
    package = pkgs.neovim;
    withRuby = false;
    withPython3 = false;
  };
}
