{...}: {
  hardware = {
    nvidia = {
      open = false;
      branch = "legacy_580";
      nvidiaSettings = true;
      modesetting.enable = true;
      powerManagement.enable = false;

      prime = {
        sync.enable = true;
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };

    graphics = {
      enable = true;
      enable32Bit = true; # Critical for Steam
    };

    i2c = {
      enable = true;
    };

    enableAllFirmware = true;
    bluetooth = {enable = true;};
    opentabletdriver = {enable = true;};
  };

  services.udev.extraHwdb = ''
    evdev:input:b0003v36B7pFD13*
      KEYBOARD_KEY_7001e=kp1
      KEYBOARD_KEY_7001f=kp2
      KEYBOARD_KEY_70020=kp3
      KEYBOARD_KEY_70021=kp4
      KEYBOARD_KEY_70022=kp5
      KEYBOARD_KEY_70023=kp6
      KEYBOARD_KEY_70024=kp7
      KEYBOARD_KEY_70025=kp8
      KEYBOARD_KEY_70026=kp9
      KEYBOARD_KEY_70027=kp0
      KEYBOARD_KEY_70057=kpplus
      KEYBOARD_KEY_70056=kpminus
  '';

  services.keyd = {
    enable = true;
    keyboards.arm_mouse_kp = {
      ids = ["36b7:fd13"];
      settings = {
        main = {}; # sem remaps — só queremos que o keyd absorva e unifique o device
      };
    };
  };

  services.udev.extraRules = ''
    KERNEL=="i2c-[0-9]*", GROUP="i2c", MODE="0660"
  '';
}
