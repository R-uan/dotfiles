{
  stdenv,
  fetchFromGitHub,
}: {
  sddm-themes.r1999_1 = stdenv.mkDerivation rec {
    pname = "R1999_1";
    version = "main";
    dontBuild = true;
    installPhase = ''
      mkdir -p $out/share/sddm/themes
      cp -aR $src/themes/R1999_1 $out/share/sddm/themes/${pname}
    '';
    src = fetchFromGitHub {
      owner = "Darkkal44";
      repo = "qylock";
      rev = "${version}";
      sha256 = "sha256-9A/nzv9XOx12nd9UO8dZsd6j18YtVdkZ2p984m+qJiY=";
    };
  };
}