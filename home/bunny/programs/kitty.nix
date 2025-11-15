{ config, pkgs, ... }: {
  programs.kitty  = {
    enable = true;

    # Fonts
    # font = {
        # name = "Fira Code";
        # size = 14;
    # };

    settings = {
        enable_audio_bell = "no";
        window_padding_width = 3;
        remember_window_size = "yes";
        initial_window_width = 740;
        initial_window_height = 600;

        foreground = "#E6DFF0";
        background = "#17131A";
        background_opacity = "0.93";

        selection_foreground = "#17131A";
        selection_background = "#8B6FB4";

        cursor = "#E6DFF0";
        cursor_text_color = "#312936";

        url_color = "#C6A5BC";

        active_border_color = "#8B6FB4";
        inactive_border_color = "#6E5898";
        bell_border_color = "#9BB27A";

        wayland_titlebar_color = "#221B26";
        macos_titlebar_color = "#221B26";

        active_tab_foreground = "#E6DFF0";
        active_tab_background = "#8B6FB4";
        inactive_tab_foreground = "#BFB3CB";
        inactive_tab_background = "#221B26";
        tab_bar_background = "#221B26";

        mark1_foreground = "#312936";
        mark1_background = "#8B6FB4";
        mark2_foreground = "#312936";
        mark2_background = "#6E5898";
        mark3_foreground = "#DAE8D0";
        mark3_background = "#789659";

        color0 = "#17131A";
        color1 = "#C6A5BC";
        color2 = "#789659";
        color3 = "#9BB27A";
        color4 = "#8B6FB4";
        color5 = "#6E5898";
        color6 = "#B7A1D3";
        color7 = "#E6DFF0";

        color8  = "#221B26";
        color9  = "#C6A5BC";
        color10 = "#789659";
        color11 = "#DAE8D0";
        color12 = "#8B6FB4";
        color13 = "#B7A1D3";
        color14 = "#BFB3CB";
        color15 = "#E6DFF0";
    };
  };
}
