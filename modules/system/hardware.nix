{...}: {
  hardware = {
    # amdgpu cobre a iGPU do Ryzen e a RX 7600 — Mesa já fornece RADV (Vulkan) e VA-API.
    # Carrega no initrd (KMS cedo, Plymouth na resolução certa)
    amdgpu.initrd.enable = true;

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
