{ pkgs, lib, ... }:

let
  palette = builtins.fromJSON (builtins.readFile ../palette.json);
in
rec {
  username = "bunny";
  dotfilesDir = "/home/${username}/dotfiles";

  loadPalette = mode:
    if builtins.hasAttr mode palette
    then palette.${mode}
    else throw "palette.json has no mode '${mode}' (use 'dark' or 'light')";

  paletteDark = palette.dark;
  paletteLight = palette.light;

  mkRebuildScript = pkgs.writeShellScriptBin "rebuild" ''
    exec nixos-rebuild switch --flake ${dotfilesDir}#bunny "$@"
  '';
}
