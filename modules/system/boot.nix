# modules/boot.nix
{ ... }: {
  boot = {
    loader = {
      efi = {
        canTouchEfiVariables = true;
      };

      systemd-boot = {
        enable = true;
        configurationLimit = 5;
      };
    };

    kernelModules = [
      "i2c-dev"
    ];

    kernelParams = [
      "quiet"
      "splash"
      "udev.log_level=3"
      "rd.udev.log_level=3"
      "rd.systemd.show_status=false"
    ];

    consoleLogLevel = 0;
    plymouth.enable = true;
  };
}