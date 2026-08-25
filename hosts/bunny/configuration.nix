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
    ignoreShellProgramCheck = true;
    
    extraGroups = [
      "i2c"
      "wheel" 
      "docker" 
      "networkmanager" 
    ];
  };

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
    allowUnfreePredicate = pkg:
      builtins.elem (pkgs.lib.getName pkg) [
        "cloudflare-warp"
      ];
  };
}
