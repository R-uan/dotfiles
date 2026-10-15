# Home-server headless: sem interface gráfica, acesso só por SSH
{...}: {
  imports = [
    ./ssh.nix
  ];

  # Sempre ligado: nada de suspender/hibernar
  systemd.targets = {
    sleep.enable = false;
    suspend.enable = false;
    hibernate.enable = false;
    hybrid-sleep.enable = false;
  };
}
