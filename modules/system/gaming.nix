{...}: {
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  # Gamescope: compositor isolado p/ Wayland/HDR e menos bugs de janela em jogos
  # (uso: `gamescope -W 2560 -H 1440 -r 144 -f -- %command%` nas opções do Steam)
  programs.gamescope = {
    enable = true;
    capSysNice = true; # permite subir prioridade sem ser root
  };

  # CoreCtrl: GUI p/ curvas de fan e undervolt na RX 7600.
  # Precisa do ppfeaturemask em kernelParams p/ destravar edição de tensão/clock.
  programs.corectrl.enable = true;

  programs.gamemode = {
    enable = true;
    enableRenice = true;
    settings = {
      general = {
        renice = 10; # how aggressively it boosts process priority
        desiredgov = "performance"; # troca o governor durante o jogo e volta depois
      };
      cpu = {
        park_cores = "no";
        pin_cores = "no";
      };
    };
  };
}
