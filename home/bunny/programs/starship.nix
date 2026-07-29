{
  config,
  pkgs,
  ...
}: {
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      palette = "Bunny";
      format = ''$directory $character'';
      right_format = ''$git_branch'';
      add_newline = false;

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
        style_user = "fg:#a6a6a6 bold";
        format = " [$symbol$environment](dimmed #6e6e6e) ";
      };

      character = {
        success_symbol = "[🐇](#8e8e8e bold)";
        error_symbol = "[🐇](#c4c4c4)";
        vicmd_symbol = "[🐇](#a6a6a6)";
      };

      directory = {
        format = "[  ](fg:#6e6e6e)[$path](fg:#6e6e6e bold)";
        style = "fg:#c4c4c4";
        truncation_length = 3;
        truncate_to_repo = false;
      };

      git_branch = {
        format = "[[  ](fg:#6e6e6e bold)$branch](fg:#6e6e6e bold)";
        style = "fg:#303030";
      };

      git_status = {
        format = "[$all_status$ahead_behind](fg:#303030) ";
        style = "fg:#7e7e7e";
        conflicted = "=";
        ahead = "⇡\${count}";
        behind = "⇣\${count}";
        diverged = "⇕⇡\${ahead_count}⇣\${behind_count}";
        up_to_date = "";
        untracked = "?\${count}";
        stashed = "";
        modified = "!\${count}";
        staged = "+\${count}";
        renamed = "»\${count}";
        deleted = "\${count}";
      };

      palettes = {
        Bunny = {
          background    = "#151515";
          primary       = "#6e6e6e";
          dprimary      = "#303030";
          lprimary      = "#c4c4c4";
          green         = "#8e8e8e";
          complementary = "#7e7e7e";
          accent        = "#a6a6a6";
          rose          = "#c4c4c4";
          pink          = "#a4a4a4";
        };
      };
    };
  };
}
