{ stdenv, makeBinaryWrapper, unzip, autoPatchelfHook, SDL2, libGL }:
stdenv.mkDerivation {
  name="eggnoggplus";
  src = ./eggnoggplus-linux.zip;
  nativeBuildInputs = [
    autoPatchelfHook
    unzip
    makeBinaryWrapper
  ];
  buildInputs = [
    SDL2
    libGL
  ];

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/usr/share

    mv eggnoggplus $out/bin
    mv data $out/usr/share

    wrapProgram $out/bin/eggnoggplus --chdir $out/usr/share
    '';
}
