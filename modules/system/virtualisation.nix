{...}: {
  virtualisation.docker = {
    enable = true;
    extraOptions = "--data-root=/mnt/hdd/docker";
    rootless = {
      enable = true;
      setSocketVariable = true;

      daemon.settings = {
        dns = [
          "1.1.1.1" 
          "8.8.8.8"
        ];
        registry-mirrors = [
          "https://mirror.gcr.io"
        ];
      };
    };
  };

  systemd.services.docker.serviceConfig = {
    MemoryMax = "4G";
    CPUQuota = "200%";
  };
}
