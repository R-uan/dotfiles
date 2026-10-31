{
  ...
}: {
  programs.kitty = {
    enable = true;

    font = {
      name = "Iosevka";
      size = 12;
    };

    settings = {
      enable_audio_bell = "no";
      window_padding_width = 6;
      remember_window_size = "yes";
      initial_window_width = 740;
      initial_window_height = 600;
      background_opacity = "0.91";
      dynamic_background_opacity = "yes";
      confirm_os_window_close = 0;
      update_check_interval = 0; # nix updates it

      # Cursor: a short trail when it jumps (nvim, tmux-like hops)
      cursor_shape = "beam";
      cursor_trail = 3;
      cursor_trail_decay = "0.1 0.3";

      # Scrollback and copying
      scrollback_lines = 10000;
      strip_trailing_spaces = "smart";
      url_style = "curly";

      # Desktop notification (mako) when a command over 15s finishes
      # while the window isn't focused. Needs shell integration (on by default).
      notify_on_cmd_finish = "unfocused 15";

      # Splits instead of the default tiling layouts
      enabled_layouts = "splits,stack";

      tab_title_template = "{index}: {title.split('/')[-1]}";
      tab_bar_style = "powerline";
      tab_powerline_style = "slanted";

      foreground = "#c4c4c4";
      background = "#151515";
      selection_foreground = "#151515";
      selection_background = "#6e6e6e";
      cursor = "#c4c4c4";
      cursor_text_color = "#151515";
      url_color = "#8a8a8a";

      active_border_color = "#6e6e6e";
      inactive_border_color = "#303030";
      bell_border_color = "#a4a4a4";
      wayland_titlebar_color = "#151515";
      macos_titlebar_color = "#1c1c1c";

      active_tab_foreground = "#151515";
      active_tab_background = "#6e6e6e";
      inactive_tab_foreground = "#c4c4c4";
      inactive_tab_background = "#1c1c1c";
      tab_bar_background = "#151515";

      mark1_foreground = "#151515";
      mark1_background = "#6e6e6e";
      mark2_foreground = "#151515";
      mark2_background = "#7e7e7e";
      mark3_foreground = "#151515";
      mark3_background = "#a6a6a6";

      color0 = "#1a1a1a";
      color1 = "#c4c4c4";
      color2 = "#8e8e8e";
      color3 = "#a4a4a4";
      color4 = "#4a4a4a";
      color5 = "#8a8a8a";
      color6 = "#a6a6a6";
      color7 = "#c4c4c4";

      color8 = "#252525";
      color9 = "#c4c4c4";
      color10 = "#6e6e6e";
      color11 = "#c4c4c4";
      color12 = "#6e6e6e";
      color13 = "#a6a6a6";
      color14 = "#c4c4c4";
      color15 = "#e0e0e0";
    };

    keybindings = {
      # New windows/tabs open in the current directory
      "ctrl+shift+enter" = "launch --cwd=current --location=vsplit";
      "ctrl+shift+minus" = "launch --cwd=current --location=hsplit";
      "ctrl+shift+t" = "new_tab_with_cwd";
      # Zoom the current split
      "ctrl+shift+z" = "toggle_layout stack";
      # Move between splits
      "ctrl+alt+h" = "neighboring_window left";
      "ctrl+alt+j" = "neighboring_window down";
      "ctrl+alt+k" = "neighboring_window up";
      "ctrl+alt+l" = "neighboring_window right";
    };
  };
}
