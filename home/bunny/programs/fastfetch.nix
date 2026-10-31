{
  config,
  pkgs,
  ...
}: {
  programs.fastfetch = {
    enable = true;
    settings = {
      logo = {
        source = "${config.xdg.configHome}/fastfetch/ffimage.png";
        type = "kitty";
        height = 15;
        padding = {
          top = 0;
          left = 0;
        };
      };
      display = {"separator" = " ›  ";};

      modules = [
        {
          type = "title";
          key = "  USR ";
          keyColor = "37";
        }

        {
          type = "separator";
          string = "┌────────────────────────────────────────┐";
          length = 1;
        }

        {
          type = "os";
          format = "{3}";
          key = "  OPS ";
          keyColor = "33";
        }

        {
          type = "kernel";
          key = "  KNL ";
          keyColor = "33";
        }

        {
          type = "wm";
          key = "  WIM ";
          keyColor = "33";
        }

        {
          type = "shell";
          key = "  SHL ";
          keyColor = "32";
        }

        {
          type = "terminal";
          key = "  TER ";
          keyColor = "32";
        }

        {
          type = "uptime";
          key = "  UPT ";
          keyColor = "32";
        }

        # 37, not 34: kitty's blue is #4a4a4a, near invisible on the background
        {
          type = "cpu";
          format = "{1}";
          key = "  CPU ";
          keyColor = "37";
        }

        {
          type = "gpu";
          format = "{1} {2}";
          key = "  GPU ";
          keyColor = "37";
        }

        {
          type = "memory";
          key = "  MEM ";
          keyColor = "37";
        }

        # / is a tmpfs; these are the real disks
        {
          type = "disk";
          folders = "/nix:/mnt/hdd";
          format = "{size-used} / {size-total} ({size-percentage}) · {mountpoint}";
          key = "  DSK ";
          keyColor = "37";
        }

        {
          type = "separator";
          string = "└────────────────────────────────────────┘";
          length = 1;
        }

        "break"
        {
          type = "colors";
          symbol = "circle";
          paddingLeft = 2;
        }
      ];
    };
  };

  xdg.configFile."fastfetch/ffimage.png".source = ../assets/ffimage.png;
}
