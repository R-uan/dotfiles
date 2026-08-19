{pkgs, ...}: {
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        no_fade_in = true;
        no_fade_out = true;
        disable_loading_bar = false;
        hide_cursor = true;
        immediate_render = true;
      };

      background = [
        {
          monitor = "";
          color = "rgb(0, 0, 0)";
          blur_passes = 1;
          contrast = 0.8916;
          brightness = 0.8172;
          vibrancy = 0.8916;
          vibrancy_darkness = 0.0;
        }
      ];

      label = [
        # Day-Month-Date
        {
          monitor = "";
          text = ''cmd[update:1000] echo -e "$(date +"%A, %B %d - %I:%M")"'';
          color = "rgb(200, 200, 200)";
          font_size = 15;
          position = "0, 500";
          halign = "center";
          valign = "center";
        }
        # Authenticate label
        {
          monitor = "";
          text = " Authenticate into archlinux";
          color = "rgba(216, 222, 233, 0.80)";
          font_size = 11;
          position = "-130, 50";
          halign = "center";
          valign = "center";
          zindex = 5;
        }
        # Username
        {
          monitor = "";
          text = "<b> Username: $USER </b>";
          color = "rgba(216, 222, 233, 0.80)";
          font_size = 11;
          position = "-150, 15";
          halign = "center";
          valign = "center";
          zindex = 1;
        }
        # Password
        {
          monitor = "";
          text = "<b> Password: </b>";
          color = "rgba(216, 222, 233, 0.80)";
          font_size = 11;
          position = "-190, -15";
          halign = "center";
          valign = "center";
          zindex = 5;
        }
        # Notification
        {
          monitor = "";
          text = "";
          color = "rgba(255, 255, 255, 0.90)";
          font_size = 14;
          position = "0, 400";
          halign = "center";
          valign = "center";
          zindex = 10;
        }
      ];

      shape = [
        # Authenticate box
        {
          monitor = "";
          size = "500, 100";
          color = "rgba(0, 0, 0, 0)";
          rounding = 0;
          border_size = 2;
          border_color = "rgba(255, 255, 255, 1)";
          rotate = 0;
          position = "0, 0";
          halign = "center";
          valign = "center";
        }
        # User box
        {
          monitor = "";
          size = "200, 20";
          color = "rgb(0, 0, 0)";
          rounding = 0;
          border_size = 2;
          border_color = "rgb(0, 0, 0)";
          rotate = 0;
          position = "-130, 50";
          halign = "center";
          valign = "center";
          zindex = 5;
        }
      ];

      input-field = [
        {
          monitor = "";
          size = "200, 50";
          outline_thickness = -1;
          dots_size = 0.2;
          dots_spacing = 0.2;
          dots_center = false;
          outer_color = "rgba(0, 0, 0, 0)";
          inner_color = "rgba(0, 0, 0, 0)";
          font_color = "rgb(255, 255, 255)";
          fade_on_empty = false;
          placeholder_text = "";
          hide_input = false;
          position = "800, -15";
          halign = "left";
          valign = "center";
        }
      ];
    };
  };
}