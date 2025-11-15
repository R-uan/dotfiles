# nbfc.nix
{
  config,
  inputs,
  nbfc-linux,
  pkgs,
  ...
}: let
  myUser = "bunny";
  command = "bin/nbfc_service --config-file '/home/${myUser}/.config/nbfc.json'";
in {
  environment.systemPackages = with pkgs; [
    nbfc-linux.packages.x86_64-linux.default
  ];

  systemd.services.nbfc_service = {
    enable = true;
    description = "NoteBook FanControl service";
    serviceConfig.Type = "simple";
    path = [pkgs.kmod];

    script = "${nbfc-linux.packages.x86_64-linux.default}/${command}";
    wantedBy = ["multi-user.target"];
  };
}
