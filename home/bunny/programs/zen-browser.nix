{
  inputs,
  ...
}: {
  imports = [
    inputs.zen-browser.homeModules.beta
  ];

  programs.zen-browser = {
    enable = true;

    # Extensions are installed from addons.mozilla.org on startup
    # Extension data (Bitwarden login, uBlock lists...) stays in the profile, not here
    policies.ExtensionSettings = let
      mkExtensionSettings = builtins.mapAttrs (_: slug: {
        install_url = "https://addons.mozilla.org/firefox/downloads/latest/${slug}/latest.xpi";
        installation_mode = "force_installed";
      });
    in
      mkExtensionSettings {
        "uBlock0@raymondhill.net" = "ublock-origin";
        "addon@darkreader.org" = "darkreader";
        "{446900e4-71c2-419f-a6a7-df9c091e268b}" = "bitwarden-password-manager";
        "vpn@proton.ch" = "proton-vpn-firefox-extension";
        "seventv-next@7tv.app" = "7tv-new";
        "{60493d8c-aec8-448e-a247-5d2cfa047d69}" = "ambient-light-for-youtube";
        "{7d1f7c5e-0f6f-4bba-82a3-04d859512523}" = "detailed-seo-extension";
      };

    profiles.default = {
      id = 0;
      isDefault = true;
      name = "Default Profile";
      # Reuse the existing profile so cookies, history and logins are kept
      path = "6z8kj8u2.Default Profile";

      # Mods from the Zen theme store (https://zen-browser.app/mods)
      mods = [
        "1b88a6d1-d931-45e8-b6c3-bfdca2c7e9d6" # Remove Tab X
        "e74cb40a-f3b8-445a-9826-1b1b6e41b846" # Custom uiFont
        "c01d3e22-1cee-45c1-a25e-53c0f180eea8" # Ghost Tabs
        "87196c08-8ca1-4848-b13b-7ea41ee830e7" # Tab Preview Enhanced
        "4ab93b88-151c-451b-a1b7-a1e0e28fa7f8" # No Sidebar Scrollbar
      ];

      # Toolbar placement of extension buttons, merged into Zen's saved layout
      extensionButtons = {
        "nav-bar" = [
          "{446900e4-71c2-419f-a6a7-df9c091e268b}" # Bitwarden
          "uBlock0@raymondhill.net"
          "{7d1f7c5e-0f6f-4bba-82a3-04d859512523}" # Detailed SEO
          "vpn@proton.ch"
        ];
        "unified-extensions-area" = [
          "seventv-next@7tv.app"
          "{60493d8c-aec8-448e-a247-5d2cfa047d69}" # Ambient Light
          "addon@darkreader.org"
        ];
      };

      # Written to user.js, applied on every startup
      settings = {
        # Zen
        "zen.welcome-screen.seen" = true;
        "zen.tabs.select-recently-used-on-close" = false;
        "zen.view.compact.enable-at-startup" = false;
        "zen.view.sidebar-expanded" = false;
        "zen.view.use-single-toolbar" = false;
        "zen.view.window.scheme" = 0;
        "layout.css.prefers-color-scheme.content-override" = 0;

        # Browser
        "browser.urlbar.suggest.engines" = false;
        "browser.translations.neverTranslateLanguages" = "pt";
        "findbar.entireword" = true;
        "findbar.highlightAll" = true;

        # Mod preferences
        "mod.remove-tab-x.scope" = "all";
        "theme.custom_uifont.custom" = "iosevka";
        "theme.custom_uifont.default" = "Custom";
        "theme.custom_uifont.shadow" = "none";
        "theme.nosidebarscrollbar.before125b" = false;
      };
    };
  };
}
