{ lib, mkDerivation, fetchFromGitHub, qmake, pkg-config, udev
, qtmultimedia, qt3d, qtscript, alsa-lib, ola, libftdi1, libusb-compat-0_1
, libsndfile, libmad, qtquickcontrols2
}:

mkDerivation rec {
  pname = "qlcplus";
  version = "5.0.0_beta2";

  src = fetchFromGitHub {
    owner = "mcallegari";
    repo = "qlcplus";
    rev = "QLC+_${version}";
    sha256 = "sha256-7/aDfAfo3s5tRLkQljlGoe1EEDdHkWK+2Vtc5PxQCs0=";
  };

  patches = [
    #(fetchpatch {
    #  name = "qt5.15-deprecation-fixes.patch";
    #  url = "https://github.com/mcallegari/qlcplus/commit/e4ce4b0226715876e8e9e3b23785d43689b2bb64.patch";
    #  sha256 = "1zhrg6ava1nyc97xcx75r02zzkxmar0973w4jwkm5ch3iqa8bqnh";
    #})
  ];

  nativeBuildInputs = [ qmake pkg-config ];
  buildInputs = [
    qtquickcontrols2 udev qtmultimedia qtscript alsa-lib ola libftdi1 libusb-compat-0_1 libsndfile libmad qt3d
  ];

  qmakeFlags = [ "CONFIG+=qmlui" "INSTALLROOT=$(out)" ];

  env.NIX_CFLAGS_COMPILE = "-Wno-error=deprecated-declarations";

  postPatch = ''
    patchShebangs .
    sed -i -e '/unix:!macx:INSTALLROOT += \/usr/d' \
            -e "s@/etc/udev/rules.d@''${out}/lib/udev/rules.d@" \
      variables.pri
  '';

  postInstall = ''
    ln -sf $out/lib/*/libqlcplus* $out/lib
  '';

  meta = with lib; {
    description = "A free and cross-platform software to control DMX or analog lighting systems like moving heads, dimmers, scanners etc";
    maintainers = [ ];
    license = licenses.asl20;
    platforms = platforms.all;
    homepage = "https://www.qlcplus.org/";
  };
}
