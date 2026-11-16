{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../../modules/system/default.nix
    ../../modules/services/default.nix
  ];

  users.users.bunny = {
    shell = pkgs.zsh;
    isNormalUser = true;

    extraGroups = [
      "i2c"
      "wheel"
      "docker"
      "networkmanager"
    ];
  };

  # Registra o zsh em /etc/shells (necessário p/ pkexec/polkit, GameMode etc.).
  # A configuração completa fica no Home Manager.
  programs.zsh.enable = true;

  system.stateVersion = "25.05"; # Did you read the comment?

  nix = {
    settings = {
      experimental-features = [
        "nix-command" 
        "flakes"
      ];
    };
    
    gc = {
      automatic = true;
      dates = "weekly"; # or "daily"
      options = "--delete-older-than 7d";
    };
  };

  nixpkgs.config = {
    allowUnfree = true;
  };
}
