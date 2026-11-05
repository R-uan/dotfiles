# User packages, grouped by usage. Each file adds to home.packages.
{
  imports = [
    ./system.nix      # desktop/shell plumbing, fonts, CLI and TUI tools
    ./development.nix # languages, language servers, editors, dev tools
    ./programs.nix    # everyday apps, media, gaming
  ];
}
