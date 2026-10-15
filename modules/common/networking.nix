{...}: {
  services.resolved.enable = true;

  networking = {
    networkmanager = {
      enable = true;
    };
    resolvconf.useLocalResolver = false;

    nameservers = [
      "1.1.1.1"
      "8.8.8.8"
    ];
  };
}
