{ lib, stdenv, fetchzip, unzip, autoPatchelfHook }:
stdenv.mkDerivation {
  pname = "labOne";
  version = "23.10.49450";
  src = fetchzip {
    url = "https://download.zhinst.com/23.10.49450/LabOneLinux64-23.10.49450.tar.gz";
    hash = "sha256-gJInuFTNBn2RM//c9umEEVJQjflKZrUvPmRFGvCqsrE="; #lib.fakeHash;
  };
  buildInputs = [stdenv.cc.cc.lib unzip];
  nativeBuildInputs = [autoPatchelfHook];
  buildPhase = ''
    unzip Documentation/overview.zip -d Documentation/
    rm Documentation/overview.zip
    '';
  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/lib/udev/rules.d
    mv ./DataServer $out
    mv ./WebServer $out
    mv ./Firmware $out
    mv ./Documentation $out
    mv ./API $out
    mv ./Installer/udev/55-zhinst.rules $out/lib/udev/rules.d
    ln -s $out/DataServer/ziServer $out/bin
    ln -s $out/DataServer/ziDataServer $out/bin
    ln -s $out/WebServer/ziWebServer $out/bin
    '';

}
