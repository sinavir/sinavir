{ lib, stdenv, fetchzip, autoPatchelfHook, alsa-lib, curlWithGnuTls, libX11, libXext, libXrandr, libXcursor, freetype }:
stdenv.mkDerivation {
  name="X32edit";
  version="4.3";
  src = fetchzip {
    url = "https://mediadl.musictribe.com/download/software/behringer/X32/X32-Edit_LINUX_4.3.tar.gz";
    sha256 = "sha256-sdsdNDXj4tVsEgBOYYbvIUIfxQ5+lhEUVJyUGUYzJnc=";
    stripRoot = false;
  };
  nativeBuildInputs = [
    autoPatchelfHook
  ];
  buildInputs = [
      alsa-lib
      curlWithGnuTls
      freetype
      stdenv.cc.cc.lib
    ];
  runtimeDependencies = [
    libXrandr
    libXcursor
    libX11
    libXext
  ];
  installPhase = ''
    mkdir -p $out/bin
    ls
    cp X32-Edit $out/bin
    '';
}
