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
      "amdgpu.ppfeaturemask=0xffffffff" # destrava edição de tensão/clock (CoreCtrl)
    ];

    # ZRAM + swappiness alto: comprime páginas frias na própria RAM (zstd ~3×),
    # só cai no swap do NVMe (prio -2) em último caso. Alívio importante nos 8 GB.
    kernel.sysctl = {
      "vm.swappiness" = 180;
      "vm.watermark_boost_factor" = 0;
      "vm.watermark_scale_factor" = 125;
      "vm.page-cluster" = 0;
    };

    consoleLogLevel = 0;
    plymouth.enable = true;
  };

  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 50; # ~3,5 GB de device zram → ~10 GB de RAM efetiva
    priority = 100; # acima do swap do NVMe (-2)
  };
}