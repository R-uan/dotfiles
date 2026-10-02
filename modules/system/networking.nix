{pkgs, ...}: {
  services.resolved.enable = true;

  networking = {
    hostName = "ruan-nixos";
    networkmanager = {
      enable = true;
    };
    resolvconf.useLocalResolver = false;

    nameservers = [
      "1.1.1.1"
      "8.8.8.8"
    ];

    hosts = {
      "127.0.0.1" = [
        "finance.local"
        "www.mostruario.sitemidas"
        "mostruario.sitemidas"
        "painelteste.sitemidas"
        "www.site2504.sitemidas"
        "site2504.sitemidas"
        "site26-teste.sitemidas"
        "www.site26-teste.sitemidas"
        "www.novo2504.sitemidas"
        "site01.sitemidas"
        "www.site01.sitemidas"
        "site02.sitemidas"
        "www.site02.sitemidas"
        "site03.sitemidas"
        "www.site03.sitemidas"
        "site04.sitemidas"
        "www.site04.sitemidas"
        "site05.sitemidas"
        "www.site05.sitemidas"
        "site06.sitemidas"
        "www.site06.sitemidas"
        "site07.sitemidas"
        "www.site07.sitemidas"
        "site08.sitemidas"
        "www.site08.sitemidas"
        "site09.sitemidas"
        "www.site09.sitemidas"
        "site10.sitemidas"
        "www.site10.sitemidas"
        "site11.sitemidas"
        "www.site11.sitemidas"
        "site12.sitemidas"
        "www.site12.sitemidas"
        "site13.sitemidas"
        "www.site13.sitemidas"
        "site14.sitemidas"
        "www.site14.sitemidas"
        "site15.sitemidas"
        "www.site15.sitemidas"
        "site16.sitemidas"
        "www.site16.sitemidas"
        "site17.sitemidas"
        "www.site17.sitemidas"
        "site18.sitemidas"
        "www.site18.sitemidas"
        "site19.sitemidas"
        "www.site19.sitemidas"
        "site20.sitemidas"
        "www.site20.sitemidas"
        "site21.sitemidas"
        "www.site21.sitemidas"
        "site22.sitemidas"
        "www.site22.sitemidas"
        "site23.sitemidas"
        "www.site23.sitemidas"
        "site24.sitemidas"
        "www.site24.sitemidas"
        "site25.sitemidas"
        "www.site25.sitemidas"
        "site26.sitemidas"
        "www.site26.sitemidas"
        "site27.sitemidas"
        "www.site27.sitemidas"
        "site28.sitemidas"
        "www.site28.sitemidas"
        "site29.sitemidas"
        "www.site29.sitemidas"
        "site30.sitemidas"
        "www.site30.sitemidas"
      ];
    };
  };

  # Cloudflare Warp (For FFXIV Better Routing)
  systemd.services.warp-svc = {
    description = "Cloudflare WARP daemon";
    wantedBy = ["multi-user.target"];
    after = ["network-online.target"];
    wants = ["network-online.target"];

    serviceConfig = {
      ExecStart = "${pkgs.cloudflare-warp}/bin/warp-svc";
      Restart = "always";
      RestartSec = 5;
    };
  };
}
