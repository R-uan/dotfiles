# Home-server: só o ambiente de terminal
{pkgs, ...}: {
  imports = [
    ./common.nix
  ];

  # A versão completa puxa EFL/SDL/GTK (~1.6 GiB); a mínima + ImageMagick
  # (~370 MiB) ainda mostra a logo em imagem no kitty via SSH
  programs.fastfetch.package = pkgs.fastfetch.minimal.override {imageSupport = true;};
}
