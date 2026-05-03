{
  config,
  pkgs,
  ...
}: {
  programs.kitty = {
    enable = true;
    # Fonts
    font = {
      name = "Iosevka";
      size = 12;
    };
    settings = {
      enable_audio_bell = "no";
      window_padding_width = 2;
      remember_window_size = "yes";
      initial_window_width = 740;
      initial_window_height = 600;
      foreground = "#a8b9aa";
      background = "#171919";
      background_opacity = "0.95";
      selection_foreground = "#121312";
      selection_background = "#7a9b7f";
      cursor = "#a8b9aa";
      cursor_text_color = "#121312";
      url_color = "#84a089";
      active_border_color = "#7a9b7f";
      inactive_border_color = "#3d4a3e";
      bell_border_color = "#9da88d";
      wayland_titlebar_color = "#121312";
      macos_titlebar_color = "#1a1f1a";
      active_tab_foreground = "#121312";
      active_tab_background = "#7a9b7f";
      inactive_tab_foreground = "#a8b9aa";
      inactive_tab_background = "#1a1f1a";
      tab_bar_background = "#121312";
      mark1_foreground = "#121312";
      mark1_background = "#7a9b7f";
      mark2_foreground = "#121312";
      mark2_background = "#84a089";
      mark3_foreground = "#121312";
      mark3_background = "#8d9e88";
      # ANSI colors
      color0 = "#121312"; # black
      color1 = "#9d8a8a"; # red (error)
      color2 = "#7a9b7f"; # green (success)
      color3 = "#9da88d"; # yellow (warning)
      color4 = "#6b7c6e"; # blue (mid green)
      color5 = "#84a089"; # magenta (cool green)
      color6 = "#8d9e88"; # cyan (warm green)
      color7 = "#a8b9aa"; # white (light green)
      # Bright colors
      color8 = "#2d322d"; # bright black
      color9 = "#9d8a8a"; # bright red (error)
      color10 = "#8d9e88"; # bright green (warm)
      color11 = "#c5d3c6"; # bright yellow (lighter green)
      color12 = "#8a9d8f"; # bright blue (base green)
      color13 = "#84a089"; # bright magenta (cool green)
      color14 = "#a8b9aa"; # bright cyan (light green)
      color15 = "#c5d3c6"; # bright white (lightest green)
    };
  };
}
