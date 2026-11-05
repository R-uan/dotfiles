# Zed. Settings and keymaps stay writable: home-manager merges these values
# into ~/.config/zed/settings.json on each rebuild (ours win on conflicts),
# so changes made from Zed's UI to other keys are kept.
{pkgs, ...}: {
  programs.zed-editor = {
    enable = true;

    # Installed on first start (names from zed-industries/extensions).
    extensions = ["nix" "php" "lua" "toml"];

    themes.bunny = import ./theme.nix;

    userSettings = {
      # Nix handles updates; nothing to phone home.
      auto_update = false;
      telemetry = {
        diagnostics = false;
        metrics = false;
      };

      theme = {
        mode = "dark";
        dark = "Bunny Dark (blur)";
        light = "One Light";
      };

      # Fonts
      ui_font_family = "Iosevka";
      ui_font_size = 16;
      buffer_font_family = "Iosevka";
      buffer_font_size = 15;
      buffer_line_height = "comfortable";
      terminal = {
        font_family = "Iosevka";
        font_size = 13;
      };

      # Editor
      tab_size = 2;
      format_on_save = "off";
      ensure_final_newline_on_save = false;
      remove_trailing_whitespace_on_save = false;
      cursor_shape = "bar";
      scroll_beyond_last_line = "one_page";
      vertical_scroll_margin = 5;
      inlay_hints.enabled = true;
      indent_guides.coloring = "indent_aware";
      scrollbar.show = "auto";
      tabs = {
        file_icons = true;
        git_status = true;
      };

      # Layout: files and git on the left, agent on the right
      project_panel.dock = "left";
      git_panel.dock = "left";
      agent.dock = "right";
      diff_view_style = "split";
      cli_default_open_behavior = "new_window";

      # Toolchains come from nix (packages/development.nix) instead of
      # Zed downloading its own copies.
      languages = {
        Nix = {
          language_servers = ["nil" "!nixd"];
          formatter.external = {
            command = "${pkgs.alejandra}/bin/alejandra";
            arguments = ["--quiet" "--"];
          };
        };
        "C++".language_servers = ["clangd"];
        C.language_servers = ["clangd"];
      };
      lsp = {
        nil.binary.path = "${pkgs.nil}/bin/nil";
        rust-analyzer.binary.path = "${pkgs.rust-analyzer}/bin/rust-analyzer";
        clangd.binary.path = "${pkgs.clang-tools}/bin/clangd";
      };
    };
  };
}
