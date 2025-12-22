{ config, pkgs, ... }: {
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    initContent = ''
      export PATH="$HOME/.local/bin:$PATH"
      fastfetch
    '';
  };
}
