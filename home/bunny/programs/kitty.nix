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
      background_opacity        = "0.92";

      foreground                = "#c2d4bc"; # colour7
      background                = "#171919"; # background0
      selection_foreground      = "#171919"; # background0
      selection_background      = "#83977f"; # colour4 / primary0
      cursor                    = "#c2d4bc"; # colour7
      cursor_text_color         = "#171919"; # background0
      url_color                 = "#8d9e82"; # colour5 / primary1

      active_border_color       = "#83977f"; # colour4 / primary0
      inactive_border_color     = "#374a39"; # colour2
      bell_border_color         = "#a8a87a"; # warning
      wayland_titlebar_color    = "#171919"; # background0
      macos_titlebar_color      = "#1c231e"; # background1

      active_tab_foreground     = "#171919"; # background0
      active_tab_background     = "#83977f"; # colour4 / primary0
      inactive_tab_foreground   = "#c2d4bc"; # colour7
      inactive_tab_background   = "#1c231e"; # background1
      tab_bar_background        = "#171919"; # background0

      mark1_foreground          = "#171919"; # background0
      mark1_background          = "#83977f"; # colour4 / primary0
      mark2_foreground          = "#171919"; # background0
      mark2_background          = "#8d9e82"; # colour5 / primary1
      mark3_foreground          = "#171919"; # background0
      mark3_background          = "#a3b89e"; # colour6

      # ANSI colors
      color0  = "#1a2a1c"; # black          — colour0
      color1  = "#a07a7a"; # red            — error
      color2  = "#7a9e78"; # green          — success
      color3  = "#a8a87a"; # yellow         — warning
      color4  = "#5c7060"; # blue           — colour3 / primary3
      color5  = "#8d9e82"; # magenta        — colour5 / primary1
      color6  = "#a3b89e"; # cyan           — colour6
      color7  = "#c2d4bc"; # white          — colour7

      # Bright colors
      color8  = "#263328"; # bright black   — colour1
      color9  = "#a07a7a"; # bright red     — error (same)
      color10 = "#83977f"; # bright green   — colour4 / primary0
      color11 = "#c2d4bc"; # bright yellow  — colour7
      color12 = "#83977f"; # bright blue    — colour4 / primary0
      color13 = "#a3b89e"; # bright magenta — colour6
      color14 = "#c2d4bc"; # bright cyan    — colour7
      color15 = "#e8e0cd"; # bright white   — foreground1
    };
  };
}
