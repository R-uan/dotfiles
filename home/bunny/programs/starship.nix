{ config, pkgs, ... }: {
  programs.starship  = {
    enable = true;
    enableZshIntegration = true;

    settings = {
      palette = "Bunny";

      format = ''$directory $character'';

      right_format = ''$git_branch'';

      add_newline = false;

      # Disable language modules
      c.disabled = true;
      cmake.disabled = true;
      haskell.disabled = true;
      python.disabled = true;
      ruby.disabled = true;
      rust.disabled = true;
      perl.disabled = true;
      package.disabled = true;
      lua.disabled = true;
      nodejs.disabled = true;
      java.disabled = true;
      golang.disabled = true;

      username = {
        show_always = true;
        disabled = false;
        style_user = "fg:accent_pink bold";
        style_root = "fg:accent_pink bold";
        format = "[$user]($style)";
      };

      conda = {
        format = " [$symbol$environment](dimmed green) ";
      };

      character = {
        success_symbol = "[🐇](green bold)";
        error_symbol = "[🐇](rose)";
        vicmd_symbol = "[🐇](lavender)";
      };

      directory = {
        format = "[  ](fg:accent)[$path](fg:accent bold)";
        style = "fg:accent_soft";
        truncation_length = 3;
        truncate_to_repo = false;
      };

      git_branch = {
        format = "[[ ](fg:accent bold)$branch](fg:accent bold)";
        style = "fg:accent_dark";
      };

      git_status = {
        format = "[$all_status$ahead_behind](fg:accent_dark) ";
        style = "fg:complementary";
        conflicted = "=";
        ahead = "⇡\${count}";
        behind = "⇣\${count}";
        diverged = "⇕⇡\${ahead_count}⇣\${behind_count}";
        up_to_date = "";
        untracked = "?\${count}";
        stashed = "";
        modified = "!\${count}";
        staged = "+\${count}";
        renamed = "»\${count}";
        deleted = "\${count}";
      };

      palettes = {
        Bunny = {
          background = "#17131A";
          background_soft = "#221B26";
          background_alt = "#312936";
          accent = "#8B6FB4";
          accent_dark = "#6E5898";
          accent_soft = "#B7A1D3";
          accent_pink = "#C6A5BC";
          foreground = "#E6DFF0";
          foreground_muted = "#BFB3CB";
          complementary = "#789659";
          complementary_soft = "#9BB27A";
          complementary_foreground = "#DAE8D0";
        };
      };
    };
  };
}
