{ config, pkgs, ... }: {
  programs.fastfetch = {
    enable = true;
    settings = {
        logo = {
          source = "${config.xdg.configHome}/fastfetch/ffimage.jpg";
          type = "kitty";
          height = 16;
          padding = {
            top = 1;
          };
        };
        display = { "separator" = " ›  "; };

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
        type = "packages";
        format = "{2} (pacman)";
        key = "  PKG ";
        keyColor = "32";
      }

      {
        type = "cpu";
        format = "{1}";
        key = "  CPU ";
        keyColor = "34";
      }

      {
        type = "gpu";
        format = "{1} {2}";
        key = "  GPU ";
        keyColor = "34";
      }

      {
        type = "separator";
        string = "└────────────────────────────────────────┘";
        length = 1;
      }

      "break"
      "colors"
    ];
    };
  };

  xdg.configFile."fastfetch/ffimage.jpg".source = ../assets/ffimage.jpg;
}
