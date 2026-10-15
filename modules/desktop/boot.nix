{ ... }: {
  boot = {
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
