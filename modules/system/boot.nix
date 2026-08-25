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

    initrd.kernelModules = [
      "nvidia" 
      "nvidia_drm"
      "nvidia_uvm" 
      "nvidia_modeset" 
    ];

    kernelParams = [
      "quiet"
      "splash"
      "fbcon=map:1"
      "udev.log_level=3"
      "nvidia_drm.fbdev=1"
      "rd.udev.log_level=3"
      "nvidia_drm.modeset=1"
      "rd.systemd.show_status=false"
    ];

    consoleLogLevel = 0;
    plymouth.enable = true;
  };
}