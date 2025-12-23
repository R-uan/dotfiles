{ config, pkgs, ... }: {
  programs.kitty  = {
    enable = true;

    # Fonts
     font = {
         name = "Iosevka";
         size = 12;
     };

    settings = {
      enable_audio_bell = "no";
      window_padding_width = 3;
      remember_window_size = "yes";
      initial_window_width = 740;
      initial_window_height = 600;

      foreground = "#a8c69f";
      background = "#070707";
      background_opacity = "0.80";

      selection_foreground = "#070707";
      selection_background = "#7fb069";

      cursor = "#a8c69f";
      cursor_text_color = "#070707";

      url_color = "#b692d4";

      active_border_color = "#7fb069";
      inactive_border_color = "#556b47";
      bell_border_color = "#b692d4";

      wayland_titlebar_color = "#202020";
      macos_titlebar_color = "#202020";

      active_tab_foreground = "#070707";
      active_tab_background = "#7fb069";
      inactive_tab_foreground = "#a8c69f";
      inactive_tab_background = "#202020";
      tab_bar_background = "#202020";

      mark1_foreground = "#070707";
      mark1_background = "#7fb069";
      mark2_foreground = "#070707";
      mark2_background = "#b692d4";
      mark3_foreground = "#070707";
      mark3_background = "#8fc277";

      # ANSI colors
      color0 = "#070707";       # black
      color1 = "#b692d4";       # red (purple)
      color2 = "#7fb069";       # green
      color3 = "#a8c69f";       # yellow (light sage)
      color4 = "#6b4d82";       # blue (deep purple)
      color5 = "#c4a3e0";       # magenta (light purple)
      color6 = "#8fc277";       # cyan (bright green)
      color7 = "#e0e0e0";       # white

      # Bright colors
      color8  = "#2a2a2a";      # bright black
      color9  = "#d4b5e8";      # bright red (lavender)
      color10 = "#8fc277";      # bright green
      color11 = "#b8d6af";      # bright yellow (very light sage)
      color12 = "#b692d4";      # bright blue (soft purple)
      color13 = "#d4b5e8";      # bright magenta (lavender)
      color14 = "#a8c69f";      # bright cyan (light sage)
      color15 = "#e0e0e0";      # bright white
    };
  };
}
