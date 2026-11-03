{pkgs, ...}: {
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        # Quickshell's lock screen; hyprlock if quickshell isn't running
        lock_cmd = "qs -p ~/.config/quickshell ipc call lock lock || pidof hyprlock || hyprlock";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "hyprctl dispatch dpms on";
        ignore_dbus_inhibit = false;
      };

      listener = [
        {
          timeout = 300; # 5 min
          on-timeout = "loginctl lock-session";
        }
        {
          timeout = 330; # 5.5 min
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
      ];
    };
  };
}
