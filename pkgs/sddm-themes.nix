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
      rev = "6946b53626b4f3c1507ae9a78c287411df5fb36c";
      hash = "sha256-79SHhz9ATD5ZpOjmOyoVZSrqstddJOfHrs+Drw4nvk0=";
    };
  };
}
