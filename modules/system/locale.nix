{pkgs, ...}: {
  time.timeZone = "America/Bahia";
  console.keyMap = "br-abnt2";

  i18n = {
    defaultLocale = "en_GB.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "pt_BR.UTF-8";
      LC_IDENTIFICATION = "pt_BR.UTF-8";
      LC_MEASUREMENT = "pt_BR.UTF-8";
      LC_MONETARY = "pt_BR.UTF-8";
      LC_NAME = "pt_BR.UTF-8";
      LC_NUMERIC = "pt_BR.UTF-8";
      LC_PAPER = "pt_BR.UTF-8";
      LC_TELEPHONE = "pt_BR.UTF-8";
      LC_TIME = "pt_BR.UTF-8";
    };
    
    inputMethod = {
      enable = true;
      type = "fcitx5";
      fcitx5.addons = with pkgs; [
        fcitx5-gtk
        qt6Packages.fcitx5-chinese-addons
        libsForQt5.fcitx5-qt
        kdePackages.fcitx5-configtool
      ];
    };
  };

  services.xserver.xkb = {
    layout = "br";
    variant = "nodeadkeys";
  };
}
