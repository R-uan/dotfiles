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
      };

      conda = {
        style_user = "fg:pink bold";
        format = " [$symbol$environment](dimmed green) ";
      };

      character = {
        success_symbol = "[🐇](green bold)";
        error_symbol = "[🐇](rose)";
        vicmd_symbol = "[🐇](lavender)";
      };

      directory = {
        format = "[   ](fg:primary)[$path](fg:primary bold)";
        style = "fg:lprimary";
        truncation_length = 3;
        truncate_to_repo = false;
      };

      git_branch = {
        format = "[[ ](fg:primary bold)$branch](fg:primary bold)";
        style = "fg:dprimary";
      };

      git_status = {
        format = "[$all_status$ahead_behind](fg:dprimary) ";
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
          background = "#070707";
          primary = "#7fb069";
          dprimary = "#3d4a34";
          lprimary = "#a8c69f";
          complementary = "#b692d4";
          pink = "#C6A5BC";
        };
      };
    };
  };
}
