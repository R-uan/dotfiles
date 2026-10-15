{...}: {
  services.openssh = {
    enable = true; # abre a porta 22 no firewall
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      AllowUsers = ["bunny"];
    };
  };

  users.users.bunny.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBjuW/yOcpr6yhOZ4Bfvn/cYYMLJas23dy4bANdz/vZ6 rpo.lopes@hotmail.com"
  ];

  # Anuncia <hostname>.local na rede (o desktop conecta com `ssh server`)
  services.avahi = {
    enable = true;
    publish = {
      enable = true;
      addresses = true;
    };
  };

  # Permite `nixos-rebuild --target-host` a partir do desktop
  nix.settings.trusted-users = ["@wheel"];
}
