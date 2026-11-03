{...}: {
  security.pam.services.login.enableGnomeKeyring = true;
  security.pam.services.greetd.enableGnomeKeyring = true;
  # Quickshell lock screen (home/bunny/config/quickshell/windows/lock)
  security.pam.services.quickshell = {};
  services.gnome.gnome-keyring.enable = true;
}
