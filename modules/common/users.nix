{pkgs, ...}: {
  users.users.bunny = {
    shell = pkgs.zsh;
    isNormalUser = true;
    ignoreShellProgramCheck = true;

    extraGroups = [
      "wheel"
      "docker"
      "networkmanager"
    ];
  };
}
