{
  stdenv,
  fetchurl,
  patchelf,
}:
stdenv.mkDerivation rec {
  pname = "zen-browser";
  version = "latest";

  src = fetchurl {
    url = "https://github.com/zen-browser/desktop/releases/download/1.17.15b/zen.linux-x86_64.tar.xz";
    sha256 = "sha256:13ef9d59e25c61b0af9b182f89ad1a5b08eb197d9e61668f145d752dda378778";
  };

  nativeBuildInputs = [patchelf];

  installPhase = ''
    mkdir -p $out/opt/zen
    cp -r ./* $out/opt/zen

    mkdir -p $out/bin
    ln -s $out/opt/zen/zen $out/bin/zen
  '';

  postFixup = ''
    patchelf \
      --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \
      $out/opt/zen/zen
  '';
}
