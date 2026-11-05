# Monochrome dark Zed theme, same scale as kitty, nvim (forestdark) and
# quickshell (Theme.dark.qml). Two variants: opaque, and "blur", where the
# window is translucent and Hyprland blurs what's behind it (like kitty).
let
  p = {
    c0 = "#1a1a1a";
    c1 = "#252525";
    c2 = "#303030";
    c3 = "#4a4a4a";
    c4 = "#6e6e6e";
    c5 = "#8a8a8a";
    c6 = "#a6a6a6";
    c7 = "#c4c4c4";
    success = "#8e8e8e";
    warning = "#a4a4a4";
    error = "#c4c4c4";
    muted = "#505050";
    primary0 = "#6e6e6e";
    primary1 = "#7e7e7e";
    primary2 = "#2a2a2a";
    bg0 = "#151515";
    bg1 = "#1c1c1c";
    bg2 = "#242424";
    border = "#2e2e2e";
    fg0 = "#c8c8c8";
    fg1 = "#e0e0e0";
  };

  # Sets of style flags, written like the nvim colorscheme's hi() calls.
  s = color: {inherit color;};
  bold = color: {
    inherit color;
    font_weight = 700;
  };
  italic = color: {
    inherit color;
    font_style = "italic";
  };

  style = blur: let
    # In the blur variant only the window background is tinted; every
    # surface on top of it is see-through so the tint doesn't stack.
    base = if blur then p.bg0 + "e8" else p.bg0;
    surface = if blur then "#00000000" else p.bg0;
    raised = if blur then "#ffffff08" else p.bg1;
  in {
    # ── Surfaces ───────────────────────────────────────────────────────
    "background.appearance" = if blur then "blurred" else "opaque";
    background = base;
    "surface.background" = raised;
    "elevated_surface.background" = p.bg1;
    "panel.background" = surface;
    "panel.focused_border" = p.c3;
    "pane.focused_border" = p.c3;
    "pane_group.border" = p.border;
    "title_bar.background" = surface;
    "title_bar.inactive_background" = surface;
    "status_bar.background" = surface;
    "toolbar.background" = surface;
    "tab_bar.background" = surface;
    "tab.inactive_background" = surface;
    "tab.active_background" = if blur then "#ffffff0d" else p.bg2;
    "scrollbar.thumb.background" = "#ffffff1a";
    "scrollbar.thumb.hover_background" = "#ffffff2e";
    "scrollbar.thumb.border" = "#00000000";
    "scrollbar.track.background" = "#00000000";
    "scrollbar.track.border" = "#00000000";

    # ── Borders and elements ───────────────────────────────────────────
    border = p.border;
    "border.variant" = p.c1;
    "border.focused" = p.c4;
    "border.selected" = p.c4;
    "border.transparent" = "#00000000";
    "border.disabled" = p.c1;
    "element.background" = p.primary2;
    "element.hover" = "#ffffff0f";
    "element.active" = "#ffffff1a";
    "element.selected" = "#ffffff17";
    "element.disabled" = p.c0;
    "ghost_element.background" = "#00000000";
    "ghost_element.hover" = "#ffffff0f";
    "ghost_element.active" = "#ffffff1a";
    "ghost_element.selected" = "#ffffff17";
    "ghost_element.disabled" = "#00000000";
    "drop_target.background" = "#ffffff14";

    # ── Text and icons ─────────────────────────────────────────────────
    text = p.fg0;
    "text.muted" = p.c5;
    "text.placeholder" = p.muted;
    "text.disabled" = p.muted;
    "text.accent" = p.fg1;
    icon = p.c6;
    "icon.muted" = p.c4;
    "icon.disabled" = p.c3;
    "icon.placeholder" = p.c4;
    "icon.accent" = p.fg1;
    "link_text.hover" = p.fg1;

    # ── Editor ─────────────────────────────────────────────────────────
    "editor.background" = surface;
    "editor.gutter.background" = surface;
    "editor.subheader.background" = raised;
    "editor.foreground" = p.fg0;
    "editor.active_line.background" = if blur then "#ffffff08" else p.bg1;
    "editor.highlighted_line.background" = "#ffffff0d";
    "editor.line_number" = p.muted;
    "editor.active_line_number" = p.primary0;
    "editor.invisible" = p.c2;
    "editor.wrap_guide" = "#ffffff0d";
    "editor.active_wrap_guide" = "#ffffff1a";
    "editor.indent_guide" = "#ffffff0d";
    "editor.indent_guide_active" = "#ffffff26";
    "editor.document_highlight.read_background" = "#ffffff12";
    "editor.document_highlight.write_background" = "#ffffff1a";
    "editor.document_highlight.bracket_background" = "#ffffff1a";
    "search.match_background" = "#ffffff26";
    "terminal.background" = surface;
    "terminal.foreground" = p.c7;
    "terminal.bright_foreground" = p.fg1;
    "terminal.dim_foreground" = p.c4;

    # Same ANSI colours as kitty.
    "terminal.ansi.black" = p.c0;
    "terminal.ansi.red" = p.c7;
    "terminal.ansi.green" = "#8e8e8e";
    "terminal.ansi.yellow" = "#a4a4a4";
    "terminal.ansi.blue" = p.c3;
    "terminal.ansi.magenta" = p.c5;
    "terminal.ansi.cyan" = p.c6;
    "terminal.ansi.white" = p.c7;
    "terminal.ansi.bright_black" = p.c1;
    "terminal.ansi.bright_red" = p.c7;
    "terminal.ansi.bright_green" = p.c4;
    "terminal.ansi.bright_yellow" = p.c7;
    "terminal.ansi.bright_blue" = p.c4;
    "terminal.ansi.bright_magenta" = p.c6;
    "terminal.ansi.bright_cyan" = p.c7;
    "terminal.ansi.bright_white" = p.fg1;
    "terminal.ansi.dim_black" = p.c0;
    "terminal.ansi.dim_red" = p.c5;
    "terminal.ansi.dim_green" = p.c4;
    "terminal.ansi.dim_yellow" = p.c5;
    "terminal.ansi.dim_blue" = p.c2;
    "terminal.ansi.dim_magenta" = p.c4;
    "terminal.ansi.dim_cyan" = p.c5;
    "terminal.ansi.dim_white" = p.c6;

    # ── Status (diagnostics, git, ...) ─────────────────────────────────
    # Monochrome like the rest: severity reads as brightness.
    error = p.error;
    "error.background" = "#c4c4c41a";
    "error.border" = p.c4;
    warning = p.warning;
    "warning.background" = "#a4a4a414";
    "warning.border" = p.c3;
    info = p.c5;
    "info.background" = "#8a8a8a14";
    "info.border" = p.c3;
    hint = p.c4;
    "hint.background" = "#6e6e6e14";
    "hint.border" = p.c2;
    success = p.success;
    "success.background" = "#8e8e8e14";
    "success.border" = p.c3;
    created = p.success;
    "created.background" = "#8e8e8e1a";
    "created.border" = p.c3;
    modified = p.warning;
    "modified.background" = "#a4a4a41a";
    "modified.border" = p.c3;
    deleted = p.c4;
    "deleted.background" = "#6e6e6e1a";
    "deleted.border" = p.c3;
    conflict = p.fg1;
    "conflict.background" = "#e0e0e01a";
    "conflict.border" = p.c4;
    ignored = p.muted;
    "ignored.background" = "#00000000";
    "ignored.border" = p.c2;
    hidden = p.muted;
    "hidden.background" = "#00000000";
    "hidden.border" = p.c2;
    renamed = p.c6;
    "renamed.background" = "#a6a6a61a";
    "renamed.border" = p.c3;
    unreachable = p.muted;
    "unreachable.background" = "#00000000";
    "unreachable.border" = p.c2;
    predictive = p.c3;
    "predictive.background" = "#00000000";
    "predictive.border" = p.c2;
    "version_control.added" = p.success;
    "version_control.modified" = p.warning;
    "version_control.deleted" = p.c4;

    players = [
      {
        cursor = p.c7;
        background = p.c7;
        selection = "#ffffff26";
      }
      {
        cursor = p.c5;
        background = p.c5;
        selection = "#8a8a8a33";
      }
    ];

    # ── Syntax: same mapping as forestdark.lua ─────────────────────────
    syntax = {
      comment = italic p.muted;
      "comment.doc" = italic p.c4;
      string = s p.c7;
      "string.escape" = s p.c5;
      "string.regex" = s p.c6;
      "string.special" = s p.c5;
      "string.special.symbol" = s p.c6;
      number = s p.c6;
      boolean = bold p.c5;
      constant = s p.c6;
      variable = s p.fg0;
      "variable.special" = italic p.c6;
      property = s p.c6;
      function = bold p.primary1;
      constructor = bold p.c6;
      keyword = bold p.primary0;
      operator = s p.c5;
      preproc = s p.c5;
      type = s p.c6;
      enum = s p.c6;
      variant = s p.c6;
      attribute = s p.c5;
      tag = s p.primary0;
      label = s p.c5;
      punctuation = s p.c4;
      "punctuation.bracket" = s p.c4;
      "punctuation.delimiter" = s p.c4;
      "punctuation.list_marker" = s p.c5;
      "punctuation.special" = s p.c5;
      embedded = s p.fg0;
      title = bold p.fg1;
      emphasis = italic p.fg0;
      "emphasis.strong" = bold p.fg1;
      link_text = s p.c6;
      link_uri = italic p.c5;
      "text.literal" = s p.c7;
      hint = italic p.c4;
      predictive = italic p.c3;
    };
  };
in {
  "$schema" = "https://zed.dev/schema/themes/v0.2.0.json";
  name = "Bunny";
  author = "bunny";
  themes = [
    {
      name = "Bunny Dark";
      appearance = "dark";
      style = style false;
    }
    {
      name = "Bunny Dark (blur)";
      appearance = "dark";
      style = style true;
    }
  ];
}
